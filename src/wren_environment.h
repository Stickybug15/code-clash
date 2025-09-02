#ifndef TREESITTER_H
#define TREESITTER_H

#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/classes/node2d.hpp"
#include "godot_cpp/classes/ref.hpp"
#include "godot_cpp/classes/thread.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "wren.hpp"
#include <gdextension_interface.h>
#include <godot_cpp/classes/label.hpp>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

namespace godot {

class WrenEnvironment : public Node {
  GDCLASS(WrenEnvironment, Node)

private:
protected:
  static void _bind_methods();

public:
  WrenEnvironment();
  ~WrenEnvironment();

  void _ready() override;
  void _process(double delta) override;
  void _enter_tree() override;
  void _exit_tree() override;

  void run_interpreter(String code);

  void set_action_manager(Node2D *node);
  Node2D *get_action_manager();
  void set_actor(Node2D *p_actor);
  Node2D *get_actor();
  void set_component_manager(Node *p_component_manager);
  Node *get_component_manager();

  String make_classes() const;

  WrenVM *vm;
  Array actions;
  Node2D *actor{nullptr};
  Node2D *action_manager{nullptr};
  Node *component_manager{nullptr};

  Dictionary foreign_method_cache;
};

} // namespace godot

#endif
