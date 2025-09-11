#include "js_environment.h"
#include "duk_config.h"
#include "duktape.h"
#include "godot_cpp/classes/object.hpp"
#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/core/print_string.hpp"
#include "godot_cpp/variant/callable_method_pointer.hpp"
#include "godot_cpp/variant/char_string.hpp"

namespace godot {

#define GD_FORMAT(fmt, ...) String(fmt).format(Array::make(__VA_ARGS__))

void JSEnvironment::_bind_methods() {
  ClassDB::bind_method(D_METHOD("add_method", "method_info"),
                       &JSEnvironment::add_method);
  ClassDB::bind_method(D_METHOD("eval", "code"), &JSEnvironment::eval);
  ClassDB::bind_method(D_METHOD("eval_async", "code"),
                       &JSEnvironment::eval_async);
}

void duk_print_error(duk_context *ctx) {
  duk_get_prop_string(ctx, -1, "name");
  const char *name = duk_safe_to_string(ctx, -1);
  duk_pop(ctx);

  duk_get_prop_string(ctx, -1, "message");
  const char *message = duk_safe_to_string(ctx, -1);
  duk_pop(ctx);

  duk_get_prop_string(ctx, -1, "fileName");
  const char *fileName = duk_safe_to_string(ctx, -1);
  duk_pop(ctx);

  duk_get_prop_string(ctx, -1, "lineNumber");
  duk_int_t lineNumber = duk_get_int_default(ctx, -1, -1);
  duk_pop(ctx);

  duk_get_prop_string(ctx, -1, "stack");
  const char *stack = duk_safe_to_string(ctx, -1);
  duk_pop(ctx);

  print_line("error = {\n"
             "  name: {0}\n"
             "  message: {1}\n"
             "  fileName: {2}\n"
             "  lineNumber: {3}\n"
             "  stack: {4}\n"
             "}\n",
             Array::make(name, message, fileName, lineNumber, stack));
  print_error(
      GD_FORMAT("{0}:{1}: {2}: {3}", fileName, lineNumber, name, message));
  print_error(GD_FORMAT("{0}", stack));
}

void JSEnvironment::eval(String code) {
  print_line("code: ", code);
  CharString code_cs = code.ascii();

  duk_push_string(ctx, code_cs.ptr());
  duk_push_string(ctx, "main");

  if (duk_pcompile(ctx, 0) != DUK_EXEC_SUCCESS) {
    duk_print_error(ctx);
  } else {
    if (duk_pcall(ctx, 0) != DUK_EXEC_SUCCESS) {
      duk_print_error(ctx);
    }
  }
  duk_pop(ctx);
}

void JSEnvironment::eval_async(String code) {
  if (running) {
    WARN_PRINT("Interpreter is already running!");
    return;
  } else if (!first_run) {
    thread->wait_to_finish();
  }

  running = true;
  first_run = false;
  thread->start(
      callable_mp(this, &JSEnvironment::_eval_pending_code).bind(code));
}

void JSEnvironment::_eval_pending_code(String code) {
  eval(code);
  running = false;
}

void JSEnvironment::_method_finished(String full_path) {
  print_line(GD_FORMAT("finished: {0}", full_path));
  semaphore->post();
}

void JSEnvironment::add_method(Dictionary method_info) {
  CharString object_name = ((String)method_info["object_name"]).ascii();
  CharString method_name = ((String)method_info["method_name"]).ascii();

  String full_path =
      GD_FORMAT("{0}.{1}", String(object_name), String(method_name));

  print_line("method_info: ", method_info);
  duk_push_global_object(ctx);

  duk_push_pointer(ctx, this);
  duk_put_prop_string(ctx, -2, "__this");

  if (object_methods.has(full_path)) {
    print_error(full_path, " already exist. overriding it.");
  }
  object_methods[full_path] = method_info;

  if (duk_has_prop_string(ctx, -1, object_name.ptr()) != 1) {
    duk_push_object(ctx);
    duk_push_string(ctx, object_name.ptr());
    duk_put_prop_string(ctx, -2, "__name");
    duk_put_prop_string(ctx, -2, object_name.ptr());
  }

  duk_get_prop_string(ctx, -1, object_name.ptr());
  {
    duk_push_c_function(
        ctx,
        [](duk_context *ctx) {
          duk_get_global_string(ctx, "__this");
          JSEnvironment *self = (JSEnvironment *)duk_to_pointer(ctx, -1);
          duk_pop(ctx);

          duk_push_this(ctx);
          duk_get_prop_string(ctx, -1, "__name");
          const char *object_name = duk_safe_to_string(ctx, -1);
          duk_pop_2(ctx);

          duk_push_current_function(ctx);
          duk_get_prop_string(ctx, -1, "__name");
          const char *method_name = duk_safe_to_string(ctx, -1);
          duk_pop_2(ctx);

          String full_path = GD_FORMAT("{0}.{1}", object_name, method_name);

          Dictionary method_info = self->object_methods[full_path];
          String dispatch_name = method_info["dispatch_name"];

          Node *end_state =
              Object::cast_to<Node>((Object *)method_info["end_state"]);
          RefCounted *blackboard = Object::cast_to<RefCounted>(
              (Object *)end_state->get("blackboard"));
          blackboard->call("set_var", "method_name", method_name);

          end_state->call_deferred(
              "connect", "exited",
              callable_mp(self, &JSEnvironment::_method_finished)
                  .bind(full_path),
              ConnectFlags::CONNECT_ONE_SHOT);
          end_state->call_deferred("dispatch", dispatch_name);

          print_line(GD_FORMAT("start: {0}", full_path, blackboard));
          self->semaphore->wait();
          return 0;
        },
        0);
    duk_push_string(ctx, method_name.ptr());
    duk_put_prop_string(ctx, -2, "__name");
    duk_put_prop_string(ctx, -2, method_name.ptr());
  }
  duk_pop_2(ctx);
}

void JSEnvironment::_enter_tree() {
  ctx = duk_create_heap_default();
  semaphore.instantiate();
  thread.instantiate();
}

void JSEnvironment::_exit_tree() {
  if (thread->is_started()) {
    thread->wait_to_finish();
    thread.unref();
  }
  semaphore.unref();
  duk_destroy_heap(ctx);
}

} // namespace godot
