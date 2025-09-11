#pragma once

#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/classes/ref.hpp"
#include "godot_cpp/classes/semaphore.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include <gdextension_interface.h>
#include <godot_cpp/godot.hpp>
#include "duk_config.h"
#include "godot_cpp/variant/array.hpp"

namespace godot {

class JSEnvironment : public Node {
  GDCLASS(JSEnvironment, Node)

private:
protected:
  static void _bind_methods();

public:
  void _enter_tree() override;
  void _exit_tree() override;

  void eval(String code);

  void add_method(Dictionary info);
  void _method_finished(String full_path);

  duk_context *ctx{nullptr};
  Dictionary object_methods;
  Ref<Semaphore> semaphore;
};

} // namespace godot

