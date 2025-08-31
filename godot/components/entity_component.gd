class_name EntityComponent
extends Component

var components: EntityComponentManager
var velocity := Vector2.ZERO

func _ready() -> void:
	assert(get_parent() is EntityComponentManager, "Parent is not EntityComponentManager")
	components = get_parent()
