extends CanvasLayer

var sound_buttons = {'on': preload("res://assets/buttons/audioOn.png"),
					 'off': preload("res://assets/buttons/audioOff.png")}
var music_buttons = {'on': preload("res://assets/buttons/musicOn.png"),
					 'off': preload("res://assets/buttons/musicOff.png")}

func appear():
	$AnimationPlayer.play('appear')

func disappear():
	$AnimationPlayer.play_backwards('appear')

func set_sound(on):
	if on:
		$HBoxContainer/SoundButton.texture_normal = sound_buttons['on']
	else:
		$HBoxContainer/SoundButton.texture_normal = sound_buttons['off']

func set_music(on):
	if on:
		$HBoxContainer/MusicButton.texture_normal = music_buttons['on']
	else:
		$HBoxContainer/MusicButton.texture_normal = music_buttons['off']