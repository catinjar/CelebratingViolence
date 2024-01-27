class_name Bullet

extends RigidBody2D

@export var bullet_scene : PackedScene

var reload_time = 0.2
var shoot_time = 0

func _process(delta):
	update_movement(delta)
	update_shooting(delta)

func update_movement(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	var velocity = direction * 250
	
	global_position += velocity * delta

func update_shooting(delta):
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		return
	
	var closest_enemy : Enemy	
	var closest_length = INF
	for enemy in enemies:
		var direction = enemy.global_position - global_position
		if direction.length() < closest_length:
			closest_enemy = enemy
			closest_length = direction.length()
		
	var direction = closest_enemy.global_position - global_position
	
	shoot_time += delta
	
	var actual_reload_time = reload_time
	if GlobalState.has_rule(GlobalState.Rule.ULTRAVIOLENCE):
		actual_reload_time /= 2.5
	
	while shoot_time > actual_reload_time:
		var bullet = bullet_scene.instantiate()
		
		var bullets_node = get_node("/root/Main/BulletContainer")
		bullets_node.add_child(bullet)
		
		bullet.global_position = global_position
		
		var bullet_speed = 800
		
		if GlobalState.has_rule(GlobalState.Rule.ULTRAVIOLENCE):
			var bullet_direction = direction.normalized()
			bullet_direction = bullet_direction.rotated(deg_to_rad(randf_range(-30, 30)))
			bullet.linear_velocity = bullet_direction * bullet_speed
		else:
			var bullet_direction = direction.normalized()
			bullet_direction = bullet_direction.rotated(deg_to_rad(randf_range(-5, 5)))
			bullet.linear_velocity = bullet_direction * bullet_speed
		
		shoot_time -= actual_reload_time


func _on_body_entered(body):
	if body.is_in_group("money"):
		GlobalState.add_money(randi_range(5, 10))
