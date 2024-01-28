extends RigidBody2D

@export var is_flame = false
@export var health = 1

func _process(delta):
	if GlobalState.has_rule(GlobalState.Rule.CHINESE_NEW_YEAR) and is_flame:
		$Sprite2D.scale *= 1 + 0.3 * delta
		$CollisionShape2D.scale *= 1 + 0.3 * delta
	pass


func _on_body_entered(body):
	health -= 1
	if health <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
