class_name Enemy

extends RigidBody2D

@export var money_scene : PackedScene

var health = 3

func _process(delta):
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() == 0:
		return
	
	var player = players[0]
	var direction = (player.global_position - global_position).normalized()
	var velocity = direction * 100
	
	linear_velocity = velocity


func _on_body_entered(body):
	if body.is_in_group("bullets"):
		health -= 1
		if health <= 0:
			if randi_range(0, 100) < 65:
				var money = money_scene.instantiate()
				money.global_position = global_position
				var money_container = get_node("/root/Main/MoneyContainer")
				money_container.add_child(money)
			queue_free()
