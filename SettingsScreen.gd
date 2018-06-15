extends "res://Screen.gd"

signal return_to_title

var sound_buttons = {true: preload("res://assets/buttons/audioOn.png"),
					 false: preload("res://assets/buttons/audioOff.png")}
var music_buttons = {true: preload("res://assets/buttons/musicOn.png"),
					 false: preload("res://assets/buttons/musicOff.png")}

func _on_ReturnButton_pressed():
	emit_signal('return_to_title')

func _on_SoundButton_pressed():
	settings.enable_sound = !settings.enable_sound
	$Margins/Main/Buttons/SoundButton.texture_normal = sound_buttons[settings.enable_sound]

func _on_MusicButton_pressed():
	settings.enable_music = !settings.enable_music
	$Margins/Main/Buttons/MusicButton.texture_normal = music_buttons[settings.enable_music]
