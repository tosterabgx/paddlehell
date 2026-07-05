extends StaticBody2D

func hit():
	if $"..".get_child_count() == 1:
		get_tree().current_scene.won()
	
	queue_free()
