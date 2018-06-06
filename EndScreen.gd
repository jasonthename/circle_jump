extends "res://Screen.gd"

func update_scores(score, highscore):
	$VBoxContainer/Score.text = "Score: %s" % score
	$VBoxContainer/Highscore.text = "Best: %s" % highscore