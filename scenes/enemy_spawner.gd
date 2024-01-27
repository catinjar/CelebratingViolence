extends Node

@export var enemy_scene : PackedScene

func _process(delta):
	pass

func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	pass # Replace with function body.
