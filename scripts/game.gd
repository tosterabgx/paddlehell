extends Node2D

@onready var brick_object = preload("res://scenes/brick.tscn")
@onready var bullet_object = preload("res://scenes/bullet.tscn")

@export var columns: int = 8
@export var rows: int = 4
@export var gap: float
@export var start_x: float
@export var start_y: float

@export var spread_degrees: float = 40.0

var is_running = false
var is_end = false

func _ready() -> void:
	setupLevel()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("confirm") && !is_running:
		is_running = true
		$Ball.is_active = true
		$Timer/HellTimer.start()
	
	if Input.is_action_just_pressed("restart") && is_end:
		get_tree().reload_current_scene()

func setupLevel() -> void:
	for r in rows:
		for c in columns:
			var brick = brick_object.instantiate()
			brick.position = Vector2(start_x + (90 + gap) * c, start_y + (36 + gap) * r)
			$Bricks.add_child(brick)

func _on_hell_timer_timeout() -> void:
	$Timer/BulletTimer.start()
	$HellMode.visible = true
	$HellMusic.playing = true
	$Camera2D.screen_shake(20, 0.2)
	$Camera2D.start_sustained_shake(4)  	

func _on_bullet_timer_timeout() -> void:
	var bullet = bullet_object.instantiate()
	var spawn = $BulletSpawnPoints.get_children().pick_random()
	bullet.global_position = spawn.global_position
	$Bullets.add_child(bullet)
	
	var direction = ($BulletTarget.global_position - spawn.global_position).normalized()
	var random_offset = deg_to_rad(randf_range(-spread_degrees / 2.0, spread_degrees / 2.0))
	direction = direction.rotated(random_offset)
	
	bullet.direction = direction
	bullet.rotation = direction.angle()
	
	bullet.connect("body_entered", lost)

func _on_lose_zone_body_entered(body: Node2D) -> void:
	lost(body)

func lost(_body: Node2D) -> void:
	$UI/YouLost.visible = true
	end()

func won() -> void:
	$UI/YouWon.visible = true
	end()

func end() -> void:
	$Ball.is_active = false
	$Timer/HellTimer.stop()
	$Timer/BulletTimer.stop()
	$Bullets.queue_free()
	is_end = true
