extends RigidBody2D

@export var is_flame = false
@export var is_love = false
@export var health = 1

func _process(delta):
	if GlobalState.has_rule(GlobalState.Rule.CHINESE_NEW_YEAR) and is_flame and $Sprite2D.scale.length() < 5:
		$FlockSprite.scale *= 1 + 0.3 * delta
		$CollisionShape2D.scale *= 1 + 0.3 * delta
		
	if GlobalState.has_rule(GlobalState.Rule.LOVE) and is_love:
		var mouse_position = get_viewport().get_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		linear_velocity = direction * 3000
		
		if (mouse_position - global_position).length() < 50:
			queue_free()


func _on_body_entered(body):
	health -= 1
	if health <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
