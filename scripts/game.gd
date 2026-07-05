extends Node2D

@onready var brickObject = preload("res://scenes/brick.tscn")

@export var columns: int = 8
@export var rows: int = 4
@export var gap: float
@export var start_x: float
@export var start_y: float

func _ready() -> void:
	setupLevel()

func setupLevel() -> void:
	for r in rows:
		for c in columns:
			var newBrick = brickObject.instantiate()
			add_child(newBrick)
			newBrick.position = Vector2(start_x + (90 + gap) * c, start_y + (36 + gap) * r)
	
	
	
	
	
