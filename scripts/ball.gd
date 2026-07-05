extends CharacterBody2D

var speed: int = 250
var is_active: bool = false

func _ready() -> void:
	velocity = Vector2.DOWN * speed

func _physics_process(delta: float) -> void:
	if is_active:
		var collision = move_and_collide(velocity * delta)
	
		if collision:
			var collider = collision.get_collider()
			
			if collider.is_in_group("player"):
				bounce_off_paddle(collider, collision.get_normal())
			else:
				velocity = velocity.bounce(collision.get_normal())
				
				if collider.has_method("hit"):
					collider.hit()

func bounce_off_paddle(paddle: Node2D, collision_normal: Vector2) -> void:
	var paddle_shape = paddle.get_node("CollisionShape2D")
	var paddle_width = paddle_shape.shape.size.x if paddle_shape.shape is RectangleShape2D else 100.0

	var offset = (global_position.x - paddle.global_position.x) / (paddle_width / 2.0)
	offset = clamp(offset, -1.0, 1.0)

	var max_bounce_angle = deg_to_rad(60)
	var bounce_angle = offset * max_bounce_angle
	
	var vertical_dir = sign(collision_normal.y) if collision_normal.y != 0 else -1.0

	velocity = Vector2(sin(bounce_angle), vertical_dir * cos(bounce_angle)) * speed
