extends RigidBody2D

var target_position = Vector2(960, 540)

func _process(delta):
	var direction = target_position - global_position
	
	if direction.length() < 100:
		target_position = Vector2(randi_range(0, 1920), randi_range(0, 1080))
	
	var velocity = direction.normalized() * 200
	linear_velocity = velocity
