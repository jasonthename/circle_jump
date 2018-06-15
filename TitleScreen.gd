extends "res://Screen.gd"

signal play
signal settings

func _on_PlayButton_pressed():
	emit_signal('play')

func _on_SettingsButton_pressed():
	emit_signal('settings')