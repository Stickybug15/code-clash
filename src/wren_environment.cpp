#include "wren_environment.h"
#include "cpp-tree-sitter.h"
#include "godot_cpp/classes/global_constants.hpp"
#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/core/error_macros.hpp"
#include "godot_cpp/core/object.hpp"
#include "godot_cpp/core/print_string.hpp"
#include "godot_cpp/core/property_info.hpp"
#include "godot_cpp/variant/array.hpp"
#include "godot_cpp/variant/callable_method_pointer.hpp"
#include "godot_cpp/variant/char_string.hpp"
#include "godot_cpp/variant/dictionary.hpp"
#include "godot_cpp/variant/variant.hpp"
#include "wren.hpp"
#include <cstring>
#include <functional>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;
using namespace std::string_literals;

void WrenEnvironment::_bind_methods() {
  ClassDB::bind_method(D_METHOD("run_interpreter", "user_code"),
                       &WrenEnvironment::run_interpreter);
  ClassDB::bind_method(D_METHOD("run_interpreter_async", "user_code"),
                       &WrenEnvironment::run_interpreter_async);
  ClassDB::bind_method(D_METHOD("initialize", "native_code", "class_names"), &WrenEnvironment::initialize);
  ClassDB::bind_method(D_METHOD("post"), &WrenEnvironment::post);

  GDVIRTUAL_BIND(_execute, "object_name", "method_name", "params");
  ClassDB::bind_method(D_METHOD("get_invokers"), &WrenEnvironment::get_invokers);
  ClassDB::bind_method(D_METHOD("is_active"), &WrenEnvironment::is_active);
	ADD_PROPERTY(PropertyInfo(Variant::ARRAY, "invokers", PROPERTY_HINT_ARRAY_TYPE, "Array", 0), "", "get_invokers");
}

void WrenEnvironment::_execute(String object_name,  String method_name, Dictionary params) {
  if (is_active()) {
    print_error("Semaphore is still active!");
    return;
  }
  GDVIRTUAL_CALL(_execute, object_name, method_name, params);
  _active = true;
  wait();
}

Array WrenEnvironment::get_invokers() const {
  return _invokers;
}

void WrenEnvironment::post() {
  if (!is_active()) {
    print_error("Semaphore is not in 'wait' state.");
    return;
  }
  _active = false;
  semaphore->post();
}

void WrenEnvironment::wait() {
  if (is_active()) {
    print_error("Semaphore is still in 'wait' state.");
    return;
  }
  _active = true;
  semaphore->wait();
}

bool WrenEnvironment::is_active() {
  return _active;
}

#define wrenCastUserData(vm, type) (static_cast<type>(wrenGetUserData(vm)));
#define wrenCastUserDataDefine(vm, type, identifier)                           \
  type identifier = wrenCastUserData(vm, type);

static void errorFn(WrenVM *vm, WrenErrorType type, const char *module,
                    int line, const char *message) {
  WrenEnvironment *self = wrenCastUserData(vm, WrenEnvironment *);
  print_error("WREN[ERROR]: ", module, ":", line, ": ", message);
}

static void writeFn(WrenVM *vm, const char *text) {
  WrenEnvironment *self = wrenCastUserData(vm, WrenEnvironment *);
  print_line_rich("WREN: ", text);
}

static WrenForeignMethodFn bindForeignMethodFn(WrenVM *vm, const char *_module,
                                               const char *_className,
                                               bool isStatic,
                                               const char *_signature) {
  WrenEnvironment *self = wrenCastUserData(vm, WrenEnvironment *);
  String module(_module);
  String class_name(_className);
  String signature(_signature);
  String signature_name(signature.substr(0, signature.find("(")));

  if (module == "native") {
    if (isStatic) {
      for (Variant action : self->get_invokers()) {
        Dictionary info = action;

        // print_line("className: ", class_name, ", signature: ", signature);
        String object_name = info["object_name"];
        if (object_name == class_name) {

          String full_path = class_name + "." + signature;
          String method_name = info["method_name"];
          // print_line("Registering method: ", full_path);
          self->invoker_db.set(full_path, info);

          if (method_name == signature_name) {
            return [](WrenVM *vm, const char *_className,
                      const char *_signature) {
              String className(_className);
              String signature(_signature);
              WrenEnvironment *self = wrenCastUserData(vm, WrenEnvironment *);

              String full_path =
                  className.substr(0, className.find(" ")) + "." + signature;
              if (!self->invoker_db.has(full_path)) {
                return;
              }

              Dictionary info = self->invoker_db[full_path];
              Array parameters = info["parameters"];

              Dictionary data;
              int argc = wrenGetSlotCount(vm);

              // TODO: handle not having pass in arguments.
              // TODO: handle duplicate arguments.
              int argi = 1;
              for (Dictionary param : parameters) {
                // "type": "int",
                // "name": "steps",
                // "description": "",
                // "default": 1,
                std::function<Variant(WrenVM*, int)> get_value = [&get_value](WrenVM* vm, int slot) -> Variant {
                  int argc = wrenGetSlotCount(vm);

                  switch (wrenGetSlotType(vm, slot)) {
                  case WREN_TYPE_BOOL:
                    return wrenGetSlotBool(vm, slot);
                  case WREN_TYPE_NUM:
                    return wrenGetSlotDouble(vm, slot);
                  case WREN_TYPE_FOREIGN:
                    return nullptr; // TODO: to be implemented.
                  case WREN_TYPE_LIST: {
                      Array result;
                      wrenEnsureSlots(vm, argc);
                      int last = argc + 1;
                      int list_length = wrenGetListCount(vm, slot);
                      for (int i = 0; i < list_length; ++i) {
                        wrenGetListElement(vm, slot, i, last);
                        result.append(get_value(vm, last));
                      }
                      return result;
                    } break;
                  case WREN_TYPE_MAP:
                    return Dictionary{}; // TODO: to be implemented.
                  case WREN_TYPE_NULL:
                    return nullptr;
                  case WREN_TYPE_STRING:
                    return wrenGetSlotString(vm, slot);
                  case WREN_TYPE_UNKNOWN:
                    return nullptr;
                  }
                  return nullptr;
                };
                data[param["name"]] = get_value(vm, argi);
                argi += 1;
              }

              //self->call("invoke", info["fsm_name"], info["dispatch_name"], signature.substr(0, signature.find("(")), data);
              self->_execute(info["object_name"], info["method_name"], data);
            };
          }
        }
      }
    }
  }

  return NULL;
}

static WrenForeignClassMethods
bindForeignClassFn(WrenVM *vm, const char *module, const char *className) {
  return {};
}

WrenLoadModuleResult loadModuleFn(WrenVM *vm, const char *name) {
  WrenLoadModuleResult result = {};
  WrenEnvironment *self = wrenCastUserData(vm, WrenEnvironment *);
  if (strcmp(name, "native") == 0) {
    result.source = self->native_code.ascii().ptr();
    print_line(result.source);
  }
  return result;
}

Dictionary map_actions_to_objects(Array actions) {
  Dictionary objects;
  for (Dictionary info : actions) {
    Array object_methods = objects.get_or_add(info["object_name"], Array{});
    object_methods.append(info);
  }
  return objects;
}

Array WrenEnvironment::get_class_names() const {
  Array names;
  for (Dictionary info : get_invokers()) {
    String name = info["object_name"];
    if (names.has(name)) {
      continue;
    }
    names.append(name);
  }
  return names;
}

String WrenEnvironment::make_classes() const {
  Dictionary objects = map_actions_to_objects(get_invokers());

  String classes;
  for (String object_name : objects.keys()) {
    String class_code;
    class_code += "class " + object_name + " {\n";
    Array method_list = objects[object_name];
    for (Dictionary method : method_list) {
      auto make_docs = [](Dictionary info) -> String {
        String out;
        if (info.has("description")) {
          String description = info["description"];
          if (!description.is_empty()) {
            out += "  /// " + description + "\n";
          }
        }
        if (info.has("parameters")) {
          Array params = info["parameters"];
          if (!params.is_empty()) {
            auto param_to_string = [](Dictionary param_info) -> String {
              String param_code;
              param_code += "  /// @param ";
              param_code += String(param_info["name"]);
              param_code += " : ";
              param_code += String(param_info["type"]);
              if (param_info.has("default")) {
                param_code += " = " + String(param_info["default"]);
              }
              if (param_info.has("description")) {
                param_code += "; " + String(param_info["description"]);
              }
              return param_code;
            };
            for (auto i = 0; i < params.size() - 1; i += 1) {
              out += param_to_string(params[i]) + "\n";
            }
            out += param_to_string(params[params.size() - 1]);
          }
        }
        return out;
      };
      auto make_method = [](Dictionary info) -> String {
        String out;
        String name = info["method_name"];
        out += "  foreign static " + name + "(";
        if (info.has("parameters")) {
          Array params = info["parameters"];
          if (!params.is_empty()) {
            for (auto i = 0; i < params.size() - 1; i += 1) {
              Dictionary info = params[i];
              out += String(info["name"]) + ", ";
            }
            Dictionary info = params[params.size() - 1];
            out += String(info["name"]);
          }
        }
        out += ")";
        return out;
      };

      String docs = make_docs(method);
      if (!docs.is_empty()) {
        class_code += docs + "\n";
      }
      class_code += make_method(method) + "\n";
    }
    classes += class_code + "}\n";
  }
  print_line(classes);
  return classes;
}

void WrenEnvironment::initialize(String native_code, Array class_names) {
  this->native_code = native_code;

  for (String name : class_names) {
    String code = R"(import "native" for )";
    code += name;
    auto result = wrenInterpret(vm, "main", code.ascii().ptr());
    switch (result) {
    case WREN_RESULT_COMPILE_ERROR: {
      print_line("Compile Error!");
    } break;
    case WREN_RESULT_RUNTIME_ERROR: {
      print_line("Runtime Error!");
    } break;
    case WREN_RESULT_SUCCESS: {
      print_line("Success!");
    } break;
    }
  }
}

void WrenEnvironment::run_interpreter(String user_code) {
  WrenInterpretResult result = wrenInterpret(vm, "main", user_code.ascii().ptr());
  switch (result) {
  case WREN_RESULT_COMPILE_ERROR: {
    print_line("Compile Error!");
  } break;
  case WREN_RESULT_RUNTIME_ERROR: {
    print_line("Runtime Error!");
  } break;
  case WREN_RESULT_SUCCESS: {
    print_line("Success!");
  } break;
  }
}

void WrenEnvironment::run_interpreter_async(String user_code) {
  if (running) {
    WARN_PRINT("Interpreter is already running!");
    return;
  } else if (!first_run) {
    thread->wait_to_finish();
  }

  running = true;
  first_run = false;
  pending_code = user_code;
  thread->start(callable_mp(this, &WrenEnvironment::_run_pending_code));
}

void WrenEnvironment::_run_pending_code() {
  run_interpreter(pending_code);
  pending_code = "";
  running = false;
}

void WrenEnvironment::_enter_tree() {
  WrenConfiguration config;
  wrenInitConfiguration(&config);
  config.errorFn = &errorFn;
  config.writeFn = &writeFn;
  config.bindForeignMethodFn = &bindForeignMethodFn;
  config.bindForeignClassFn = &bindForeignClassFn;
  config.loadModuleFn = &loadModuleFn;
  config.userData = this;
  vm = wrenNewVM(&config);
  thread.instantiate();
  semaphore.instantiate();
}

void WrenEnvironment::_exit_tree() {
  if (thread.is_valid()) {
    thread->wait_to_finish();
    thread.unref();
  }
  if (semaphore.is_valid()) {
    semaphore.unref();
  }

  wrenFreeVM(vm);
}

