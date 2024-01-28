extends CanvasLayer

func _process(delta):
	if GlobalState.has_rule(GlobalState.Rule.POSTPROCESS):
		show()
	else:
		hide()
