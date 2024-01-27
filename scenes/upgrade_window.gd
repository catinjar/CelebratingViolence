extends CanvasLayer

var rule_names = [
	"Ultraviolence",
	"Day of the dead"
]

var rule_descriptions = [
	"Give me all that ultraviolence",
	"They are coming back"
]

var first_rule = 0
var second_rule = 0

func set_rules(new_rules):
	assert(new_rules.size() == 2)
	
	first_rule = new_rules[0]
	second_rule = new_rules[1]
	
	$ColorRect/First.text = rule_names[first_rule]
	$ColorRect/Second.text = rule_names[second_rule]
	
	$ColorRect/Description.text = ""

func _on_first_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		GlobalState.add_new_rule(first_rule)
		hide()
		get_tree().paused = false


func _on_second_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		GlobalState.add_new_rule(second_rule)
		hide()
		get_tree().paused = false


func _on_first_mouse_entered():
	$ColorRect/First.set("theme_override_colors/font_color", Color("d62411"))
	$ColorRect/Second.set("theme_override_colors/font_color", Color("ffffff"))
	$ColorRect/Description.text = rule_descriptions[second_rule]


func _on_first_mouse_exited():
	$ColorRect/First.set("theme_override_colors/font_color", Color("ffffff"))
	$ColorRect/Second.set("theme_override_colors/font_color", Color("ffffff"))
	$ColorRect/Description.text = ""


func _on_second_mouse_entered():
	$ColorRect/First.set("theme_override_colors/font_color", Color("ffffff"))
	$ColorRect/Second.set("theme_override_colors/font_color", Color("d62411"))
	$ColorRect/Description.text = rule_descriptions[second_rule]


func _on_second_mouse_exited():
	$ColorRect/First.set("theme_override_colors/font_color", Color("ffffff"))
	$ColorRect/Second.set("theme_override_colors/font_color", Color("ffffff"))
	$ColorRect/Description.text = ""
