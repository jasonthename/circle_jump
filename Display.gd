extends Node

signal start_game

onready var current_screen = null

func _ready():
	yield(get_tree().create_timer(0.5), 'timeout')
	change_screen($TitleScreen)

func change_screen(new_screen):
	printt('changing to', new_screen.name)
	for node in get_tree().get_nodes_in_group('buttons'):
		node.disabled = true
	if current_screen:
		if current_screen.get_node('AnimationPlayer').is_playing():
			return
		current_screen.disappear()
		yield(current_screen.get_node('AnimationPlayer'), "animation_finished")
	current_screen = new_screen
	current_screen.appear()
	yield(current_screen.get_node('AnimationPlayer'), "animation_finished")
	for node in get_tree().get_nodes_in_group('buttons'):
		node.disabled = false

func _on_PlayButton_pressed():
	change_screen($PlayScreen)
	emit_signal('start_game')

func _on_SettingsButton_pressed():
	print("settings")
	if settings.enable_sound:
		$TransitionSound.play()
	change_screen($SettingsScreen)

func _on_ReturnButton_pressed():
	if settings.enable_sound:
		$TransitionSound.play()
	change_screen($TitleScreen)

func game_over(score):
	$EndScreen.update_scores(score, settings.highscore)
	change_screen($EndScreen)

func _on_HomeButton_pressed():
	if settings.enable_sound:
		$TransitionSound.play()
	change_screen($TitleScreen)

func _on_ReplayButton_pressed():
	change_screen($PlayScreen)
	emit_signal('start_game')

func update_score(value):
	$PlayScreen/MarginContainer/HBoxContainer/ScoreLabel.text = str(value)

func show_message(text):
	$PlayScreen.show_message(text)

func _on_SoundButton_pressed():
	settings.enable_sound = !settings.enable_sound
	$SettingsScreen.set_sound(settings.enable_sound)

func _on_MusicButton_pressed():
	settings.enable_music = !settings.enable_music
	$SettingsScreen.set_music(settings.enable_music)
