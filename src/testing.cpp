#include "testing.h"
#include "cpp-tree-sitter.h"
#include "godot_cpp/core/print_string.hpp"
#include "godot_cpp/variant/variant.hpp"
#include "wren.hpp"
#include <cstring>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;
using namespace std::string_literals;

void Testing::_bind_methods() {}

Testing::Testing() {}

Testing::~Testing() {}

#define wrenCastUserData(vm, type) (static_cast<type>(wrenGetUserData(vm)));
#define wrenCastUserDataDefine(vm, type, identifier)                           \
  type identifier = wrenCastUserData(vm, type);

static void errorFn(WrenVM *vm, WrenErrorType type, const char *module,
                    int line, const char *message) {
  Testing *self = wrenCastUserData(vm, Testing *);
  print_error(vformat("WREN[ERROR]: {}:{}: {}", module, line, message));
}
static void writeFn(WrenVM *vm, const char *text) {
  Testing *self = wrenCastUserData(vm, Testing *);
  print_line(vformat("WREN: {}", text));
}
static void print(WrenVM *vm) {
  Testing *self = wrenCastUserData(vm, Testing *);
  const char *str = wrenGetSlotString(vm, 1);
  if (self) {
    self->set_text(str);
  }
  print_line(vformat("Native: {}", str));
}
static WrenForeignMethodFn bindForeignMethodFn(WrenVM *vm, const char *module,
                                               const char *className,
                                               bool isStatic,
                                               const char *signature) {
  if (strcmp(module, "main") == 0) {
    if (strcmp(className, "Native") == 0) {
      if (strcmp(signature, "print(_)") == 0) {
        return print;
      }
    }
  }
  return NULL;
}

static WrenForeignClassMethods
bindForeignClassFn(WrenVM *vm, const char *module, const char *className) {
  return {};
}

void Testing::_ready() {
  WrenConfiguration config;
  wrenInitConfiguration(&config);
  config.errorFn = &errorFn;
  config.writeFn = &writeFn;
  config.bindForeignMethodFn = &bindForeignMethodFn;
  config.bindForeignClassFn = &bindForeignClassFn;
  config.userData = this;
  WrenVM *vm = wrenNewVM(&config);

  WrenInterpretResult result = wrenInterpret(vm, "main", R"(
                    class Native {
                      foreign static print(str)
                    }
                    Native.print("Hello, World")
                    )");
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
  print_line("here!");
  wrenFreeVM(vm);
}

void Testing::_process(double delta) {}
