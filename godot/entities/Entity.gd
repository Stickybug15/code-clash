class_name Entity
extends CharacterBody2D

@onready
var _state_chart: StateChart = $StateChart

var _is_ready: bool = false
var _first_run: bool = true

var health: float = 100.0
