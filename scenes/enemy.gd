class_name Enemy

extends RigidBody2D

@export var money_scene : PackedScene
@export var dead_enemy_scene : PackedScene
@export var is_dead = false
@export var health = 3

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
		var damage = 1
		if GlobalState.has_rule(GlobalState.Rule.DAY_OF_THE_DEAD) and not is_dead:
			damage = 3
		
		health -= damage
		if health <= 0:
			if randi_range(0, 100) < 65:
				var money_count = 1
				if is_dead:
					money_count = 2
				
				for i in money_count:
					var money = money_scene.instantiate()
					money.global_position = Vector2(global_position.x + randi_range(-50, 50), global_position.y + randi_range(-50, 50))
					var money_container = get_node("/root/Main/MoneyContainer")
					money_container.add_child(money)
				
			if randi_range(0, 100) < 50 and GlobalState.has_rule(GlobalState.Rule.DAY_OF_THE_DEAD) and not is_dead:
					var dead_enemy = dead_enemy_scene.instantiate()
					dead_enemy.global_position = global_position
					var dead_enemy_container = get_node("/root/Main/EnemySpawner")
					dead_enemy_container.add_child(dead_enemy)
				
			var death_sound = get_node("/root/MusicPlayer/DeathSound")
			death_sound.play()
			
			queue_free()
