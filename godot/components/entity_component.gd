class_name EntityComponent
extends Component

var components: EntityComponents
var velocity := Vector2.ZERO

func _ready() -> void:
	assert(get_parent() is EntityComponents, "Parent is not EntityComponents")
	components = get_parent()
