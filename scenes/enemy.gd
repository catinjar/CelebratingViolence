extends RigidBody2D

func _process(delta):
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() == 0:
		return
	
	var player = players[0]
	var direction = (player.global_position - global_position).normalized()
	var velocity = direction * 100

	global_position += velocity * delta
