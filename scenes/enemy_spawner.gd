extends Node

@export var enemy_scene : PackedScene

func _process(delta):
	pass

func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)

	var side_index = randi_range(0, 3)
	
	if side_index == 0:
		enemy.global_position = Vector2(-100, randi_range(0, 1080))
	elif side_index == 1:
		enemy.global_position = Vector2(2020, randi_range(0, 1080))
	elif side_index == 2:
		enemy.global_position = Vector2(randi_range(0, 1920), -100)
	elif side_index == 3:
		enemy.global_position = Vector2(randi_range(0, 1920), 1180)
		
	$Timer.wait_time = 0.1 if GlobalState.has_rule(GlobalState.Rule.ULTRAVIOLENCE) else 0.25
