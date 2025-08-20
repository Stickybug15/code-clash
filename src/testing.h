#ifndef TREESITTER_H
#define TREESITTER_H

#include <godot_cpp/classes/label.hpp>

namespace godot {

class Testing : public Label {
  GDCLASS(Testing, Label)

private:

protected:
  static void _bind_methods();

public:
  Testing();
  ~Testing();

  void _ready() override;
  void _process(double delta) override;
};

} // namespace godot

#endif
