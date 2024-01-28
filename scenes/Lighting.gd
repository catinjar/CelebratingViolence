extends Node


func _process(delta):
	if GlobalState.has_rule(GlobalState.Rule.HALLOWEEN):
		$CanvasModulate.show()
	else:
		$CanvasModulate.hide()
