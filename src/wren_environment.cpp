#include "wren_environment.h"
#include "cpp-tree-sitter.h"
#include "godot_cpp/classes/global_constants.hpp"
#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/core/error_macros.hpp"
#include "godot_cpp/core/object.hpp"
#include "godot_cpp/core/print_string.hpp"
#include "godot_cpp/core/property_info.hpp"
#include "godot_cpp/variant/array.hpp"
#include "godot_cpp/variant/callable_method_pointer.hpp"
#include "godot_cpp/variant/char_string.hpp"
#include "godot_cpp/variant/dictionary.hpp"
#include "godot_cpp/variant/variant.hpp"
#include "wren.h"
#include "wren.hpp"
#include <cstring>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;
using namespace std::string_literals;

void WrenEnvironment::_bind_methods() {
  ClassDB::bind_method(D_METHOD("get_action_manager"),
                       &WrenEnvironment::get_action_manager);
  ClassDB::bind_method(D_METHOD("set_action_manager", "p_action_manager"),
                       &WrenEnvironment::set_action_manager);
  ADD_PROPERTY(
      PropertyInfo(Variant::OBJECT, "action_manager", PROPERTY_HINT_NODE_TYPE),
      "set_action_manager", "get_action_manager");

  ClassDB::bind_method(D_METHOD("get_actor"), &WrenEnvironment::get_actor);
  ClassDB::bind_method(D_METHOD("set_actor", "p_actor"),
                       &WrenEnvironment::set_actor);
  ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "actor", PROPERTY_HINT_NODE_TYPE),
               "set_actor", "get_actor");

  ClassDB::bind_method(D_METHOD("get_component_manager"),
                       &WrenEnvironment::get_component_manager);
  ClassDB::bind_method(D_METHOD("set_component_manager", "p_component_manager"),
                       &WrenEnvironment::set_component_manager);
  ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "component_manager",
                            PROPERTY_HINT_NODE_TYPE),
               "set_component_manager", "get_component_manager");

  ClassDB::bind_method(D_METHOD("run_interpreter", "user_code"),
                       &WrenEnvironment::run_interpreter);
}

void WrenEnvironment::set_action_manager(Node2D *p_action_manager) {
  this->action_manager = p_action_manager;
}
Node2D *WrenEnvironment::get_action_manager() { return this->action_manager; }
void WrenEnvironment::set_actor(Node2D *p_actor) { this->actor = p_actor; }
Node2D *WrenEnvironment::get_actor() { return this->actor; }
void WrenEnvironment::set_component_manager(Node *p_component_manager) {
  this->component_manager = p_component_manager;
}
Node *WrenEnvironment::get_component_manager() {
  return this->component_manager;
}

WrenEnvironment::WrenEnvironment() {}

WrenEnvironment::~WrenEnvironment() {}

#define wrenCastUserData(vm, type) (static_cast<type>(wrenGetUserData(vm)));
#define wrenCastUserDataDefine(vm, type, identifier)                           \
  type identifier = wrenCastUserData(vm, type);

static void errorFn(WrenVM *vm, WrenErrorType type, const char *module,
                    int line, const char *message) {
  WrenEnvironment *self = wrenCastUserData(vm, WrenEnvironment *);
  print_error(vformat("WREN[ERROR]: {}:{}: {}", module, line, message));
}
static void writeFn(WrenVM *vm, const char *text) {
  WrenEnvironment *self = wrenCastUserData(vm, WrenEnvironment *);
  print_line(vformat("WREN: {}", text));
}
static void print(WrenVM *vm) {
  WrenEnvironment *self = wrenCastUserData(vm, WrenEnvironment *);
  const char *str = wrenGetSlotString(vm, 1);
  print_line(vformat("Native: {}", str));
}
static WrenForeignMethodFn bindForeignMethodFn(WrenVM *vm, const char *_module,
                                               const char *_className,
                                               bool isStatic,
                                               const char *_signature) {
  WrenEnvironment *self = wrenCastUserData(vm, WrenEnvironment *);
  if (self->action_manager == nullptr) {
    print_error("action_manager is null!");
    return NULL;
  }

  // "action_manager is null!");
  String module(_module);
  String class_name(_className);
  String signature(_signature);
  String signature_name(signature.substr(0, signature.find("(")));

  if (module == "native") {
    if (isStatic) {
      for (Variant action : self->actions) {
        Dictionary info = action;

        print_line("className: ", class_name, ", signature: ", signature);
        String object_name = info["object_name"];
        if (object_name == class_name) {

          String full_path = class_name + "." + signature;
          String method_name = info["method_name"];
          print_line("Registering method: ", full_path);
          self->foreign_method_cache.set(full_path, info);

          if (method_name == signature_name) {
            return [](WrenVM *vm, const char *_className,
                      const char *_signature) {
              String className(_className);
              String signature(_signature);
              WrenEnvironment *self = wrenCastUserData(vm, WrenEnvironment *);
              Node2D *actor = self->actor;
              Node *manager = self->component_manager;

              String full_path =
                  className.substr(0, className.find(" ")) + "." + signature;
              print_line("foreign: full_path: ", full_path);
              if (!self->foreign_method_cache.has(full_path)) {
                return;
              }
              Dictionary info = self->foreign_method_cache[full_path];
              Array parameters = info["parameters"];

              Dictionary data;
              int argc = wrenGetSlotCount(vm);

              int argi = 1;
              for (Dictionary param : parameters) {
                // "type": "int",
                // "name": "steps",
                // "description": "",
                // "default": 1,
                switch (wrenGetSlotType(vm, argi)) {
                case WREN_TYPE_BOOL:
                  data[param["name"]] = wrenGetSlotBool(vm, argi);
                  break;
                case WREN_TYPE_NUM:
                  data[param["name"]] = wrenGetSlotDouble(vm, argi);
                  break;
                case WREN_TYPE_FOREIGN:
                  break;
                case WREN_TYPE_LIST:
                  break;
                case WREN_TYPE_MAP:
                  break;
                case WREN_TYPE_NULL:
                  break;
                case WREN_TYPE_STRING:
                  data[param["name"]] = wrenGetSlotString(vm, argi);
                  break;
                case WREN_TYPE_UNKNOWN:
                  break;
                }
                argi += 1;
              }
              for (int i = 1; i <= argc; i += 1) {
              }

              Node2D *action = Object::cast_to<Node2D>(info["self"]);
              print_line(action);
              if (action) {
                print_line("actor: [", actor, "], manager: [", manager,
                           "], data: [", data, "]");
                action->call("execute", actor, manager, data);
                while (action->call("is_active", actor, manager)) {
                }
                action->call("print_string", "Hello, World");
              }
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
  if (self->action_manager == nullptr) {
    print_error("action_manager is null!");
    return result;
  }
  print_line("name: ", name);
  if (strcmp(name, "native") == 0) {
    result.source = self->make_classes().ascii().ptr();
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

String WrenEnvironment::make_classes() const {
  Dictionary objects = map_actions_to_objects(actions);

  String classes;
  for (String object_name : objects.keys()) {
    String class_code;
    class_code += "class ";
    class_code += object_name;
    class_code += " {\n";
    Array method_list = objects[object_name];
    for (Dictionary method : method_list) {
      if (!method.has_all(
              Array::make("object_name", "method_name", "parameters"))) {
        print_error("action: missing 'object_name' or 'method_name'",
                    "parameters");
      }
      auto make_docs = [](Dictionary info) -> String {
        String out;
        if (info.has("description")) {
          String description = info["description"];
          if (!description.is_empty()) {
            out += "  /// ";
            out += description;
            out += "\n";
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
                param_code += " = ";
                param_code += String(param_info["default"]);
              }
              if (param_info.has("description")) {
                param_code += "; ";
                param_code += String(param_info["description"]);
              }
              return param_code;
            };
            for (auto i = 0; i < params.size() - 1; i += 1) {
              out += param_to_string(params[i]);
              out += "\n";
            }
            out += param_to_string(params[params.size() - 1]);
          }
        }
        return out;
      };
      auto make_method = [](Dictionary info) -> String {
        String out;
        String name = info["method_name"];
        out += "  foreign static ";
        out += name;
        out += "(";
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
    class_code += "}";

    classes += class_code + "\n";
  }
  return classes;
}

void WrenEnvironment::_ready() {
  if (action_manager == nullptr) {
    print_error("action_manager is null!");
    return;
  }

  actions = action_manager->get("actions");
}

void WrenEnvironment::_process(double delta) {}

void WrenEnvironment::run_interpreter(String user_code) {
  String code;
  if (!wrenHasModule(vm, "native")) {
    code += "import \"native\" for hero\n";
    print_line("no module");
  }
  code += user_code;
  print_line("running: \n", code);
  WrenInterpretResult result = wrenInterpret(vm, "main", code.ascii().ptr());
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
  print_line("registered methods:");
  print_line(foreign_method_cache);
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
}

void WrenEnvironment::_exit_tree() { wrenFreeVM(vm); }
