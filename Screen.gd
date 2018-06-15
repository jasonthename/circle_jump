extends CanvasLayer

func appear():
	$AnimationPlayer.play('appear')
	get_tree().call_group('buttons', 'set_disabled', false)

func disappear():
	get_tree().call_group('buttons', 'set_disabled', true)
	$AnimationPlayer.play_backwards('appear')
