extends CanvasLayer

func _process(delta):
	$MoneyBar.value = GlobalState.money
	$HealthBar.value = GlobalState.health
	
