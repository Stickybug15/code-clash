extends LimboHSM


@onready
var air_hsm: LimboHSM = $Air
@onready
var ground_hsm: LimboHSM = $Ground


func _ready() -> void:
	air_hsm.initialize(self)
	air_hsm.set_active(true)
	ground_hsm.initialize(self)
	ground_hsm.set_active(true)
