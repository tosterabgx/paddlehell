extends CharacterBody2D

var speed: int = 250
var is_active: bool = true

func _ready() -> void:
	velocity = Vector2.DOWN * speed

func _physics_process(delta: float) -> void:
	if is_active:
		var collision = move_and_collide(velocity * delta)
		
		if collision:
			var collider = collision.get_collider()
			
			if collider.is_in_group("player"):
				bounce_off_paddle(collider)
			else:
				velocity = velocity.bounce(collision.get_normal())
				
				if collider.has_method("hit"):
					collider.hit()

func bounce_off_paddle(paddle: Node2D) -> void:
	var paddle_width = paddle.get_node("CollisionShape2D").shape.size.x

	var offset = (global_position.x - paddle.global_position.x) / (paddle_width / 2.0)
	offset = clamp(offset, -1.0, 1.0)

	var bounce_angle = offset * deg_to_rad(60)
	velocity = Vector2(sin(bounce_angle), -cos(bounce_angle)) * speed
