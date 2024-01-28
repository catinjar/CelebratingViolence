extends CanvasLayer

func _process(delta):
	$MoneyBar.value = GlobalState.money
	$MoneyBar.max_value = GlobalState.get_needed_money()
	$HealthBar.value = GlobalState.health
	
