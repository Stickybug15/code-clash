#pragma once

#include "godot_cpp/classes/mutex.hpp"
#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/classes/node2d.hpp"
#include "godot_cpp/classes/ref.hpp"
#include "godot_cpp/classes/semaphore.hpp"
#include "godot_cpp/classes/thread.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/core/gdvirtual.gen.inc"
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
  void _enter_tree() override;
  void _exit_tree() override;
  void _run_pending_code();

  String make_classes() const;
  Array get_class_names() const;

  void wait();

  // Exposed methods
  void initialize(String native_code, Array class_names);
  void run_interpreter(String code);
  void run_interpreter_async(String user_code);

	GDVIRTUAL3(_execute, String, String, Dictionary);
  virtual void _execute(String object_name,  String method_name, Dictionary params);
  bool is_active();
  void post();

  Array get_invokers() const;

  Ref<Thread> thread;
  Ref<Semaphore> semaphore;
  bool _active;
  Array _invokers;

  String native_code;

  WrenVM *vm{nullptr};
  String pending_code{""};
  bool running{false};
  bool first_run{true};

  Dictionary invoker_db{};
};

} // namespace godot

