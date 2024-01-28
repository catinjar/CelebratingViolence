extends AudioStreamPlayer


func _process(delta):
	if GlobalState.has_rule(GlobalState.Rule.MUSIC) and not $RickRoll.playing:
		stop()
		$RickRoll.play()
	elif not GlobalState.has_rule(GlobalState.Rule.MUSIC) and not playing:
		play()
		$RickRoll.stop()
