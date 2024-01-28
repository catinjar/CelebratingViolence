class_name Money

extends RigidBody2D

@export var is_cake = false

func _process(delta):
	var players = get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return
	
	var player = players[0]
	var direction = (player.global_position - global_position).normalized()
	var force = direction * 20
	var distance = 300
	
	if GlobalState.has_rule(GlobalState.Rule.BIRTHDAY):
		force *= -1
		distance = 600
	
	if (player.global_position - global_position).length() < distance:
		apply_force(force)

func _on_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
