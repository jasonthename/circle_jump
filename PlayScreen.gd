extends "res://Screen.gd"

func _ready():
	$Message.text = ''

func show_message(text):
	$Message.text = text
	$MessageAnimation.play('show_message')

func update_score(value):
	$Margins/Main/HBoxContainer/Score.text = str(value)