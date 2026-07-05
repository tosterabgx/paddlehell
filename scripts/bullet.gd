extends Area2D

var direction = Vector2.ZERO
var speed = 150

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_death_timer_timeout() -> void:
	queue_free()
