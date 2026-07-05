extends AnimatableBody2D

@export var min_x: float
@export var max_x: float
@export var min_y: float
@export var max_y: float

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	mouse_pos.x = clamp(mouse_pos.x, min_x, max_x)
	mouse_pos.y = clamp(mouse_pos.y, min_y, max_y)
	global_position = mouse_pos
