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


var is_opened_link = false

func _on_mood_gui_input(event):
	if is_opened_link:
		return
	
	if event is InputEventMouseButton and event.pressed:
		is_opened_link = true
		OS.shell_open("https://youtu.be/g_5kwBBDAL4?si=1GPXSZ8jqFIWljWk")
