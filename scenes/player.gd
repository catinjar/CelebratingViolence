extends RigidBody2D

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	var velocity = direction * 250
	
	global_position += velocity * delta
