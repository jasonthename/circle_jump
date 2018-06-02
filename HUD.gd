extends CanvasLayer

func _ready():
	$Message.hide()

func update_score(value):
	$MarginContainer/HBoxContainer/ScoreLabel.text = str(value)

func show_message(text):
	$Message.text = text
	$Message.show()
	$AnimationPlayer.play('show_message')