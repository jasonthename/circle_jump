extends "res://Screen.gd"

signal replay
signal home

func update_scores(score, highscore):
	$Margins/Main/Scores/Score.text = "Score: %s" % score
	$Margins/Main/Scores/Best.text = "Best: %s" % highscore

func _on_HomeButton_pressed():
	emit_signal('home')

func _on_ReplayButton_pressed():
	emit_signal('replay')