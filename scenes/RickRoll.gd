extends VideoStreamPlayer


func _process(delta):
	if GlobalState.has_rule(GlobalState.Rule.CINEMA):
		show()
	else:
		hide()
