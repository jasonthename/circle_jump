extends "res://Screen.gd"

func show_message(text):
	$Message.text = text
	$MessageAnimation.play('show_message')