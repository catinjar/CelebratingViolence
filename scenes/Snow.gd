extends GPUParticles2D

func _process(delta):
	if GlobalState.has_rule(GlobalState.Rule.NEW_YEAR):
		show()
	else:
		hide()
