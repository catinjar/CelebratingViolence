extends CanvasLayer

func _process(delta):
	$ProgressBar.value = GlobalState.money
