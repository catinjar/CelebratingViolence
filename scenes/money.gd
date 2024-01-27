extends RigidBody2D

func _process(delta):
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() == 0:
		return
	
	var player = players[0]
	var direction = (player.global_position - global_position).normalized()
	var force = direction * 1000
	
	if (player.global_position - global_position).length() < 300:
		apply_force(force)

func _on_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
