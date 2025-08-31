#ifndef TREESITTER_H
#define TREESITTER_H

#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/classes/node2d.hpp"
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

  void set_action_manager(Node2D *node);
  Node2D *get_action_manager();
  void set_actor(Node2D *p_actor);
  Node2D *get_actor();
  void set_component_manager(Node *p_component_manager);
  Node *get_component_manager();

  String make_classes() const;

  Array actions;
  Node2D *actor;
  Node2D *action_manager;
  Node *component_manager;

  Dictionary foreign_method_cache;
};

} // namespace godot

#endif
