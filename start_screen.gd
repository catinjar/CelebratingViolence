extends Node


func _on_violence_mouse_entered():
	$CanvasLayer/Violence.set("theme_override_colors/font_color", Color("d62411"))


func _on_violence_mouse_exited():
	$CanvasLayer/Violence.set("theme_override_colors/font_color", Color("ffffff"))


func _on_violence_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://main.tscn")


func _on_mood_mouse_entered():
	$CanvasLayer/Mood.set("theme_override_colors/font_color", Color("e42915"))


func _on_mood_mouse_exited():
	$CanvasLayer/Mood.set("theme_override_colors/font_color", Color("440501"))


func _on_mood_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var random_value = randi_range(0, 100)
		if random_value == 0:
			OS.shell_open("https://youtu.be/puLNuLkyvsE?si=ddMaZzOVBnXbn2xV")
		elif random_value == 1:
			OS.shell_open("https://youtu.be/jHWYT9KMnzQ?si=J707XUQEwe-sR_l1")
		else:
			OS.shell_open("https://youtu.be/g_5kwBBDAL4?si=1GPXSZ8jqFIWljWk")
