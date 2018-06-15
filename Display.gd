extends Node

signal start_game

onready var current_screen = null

func _ready():
	change_screen($TitleScreen)

func change_screen(new_screen):
	printt('changing to:', new_screen.name)
	if current_screen:
		current_screen.disappear()
		yield(current_screen.get_node('AnimationPlayer'), "animation_finished")
	current_screen = new_screen
	current_screen.appear()
	yield(current_screen.get_node('AnimationPlayer'), "animation_finished")

func game_over(score):
	$EndScreen.update_scores(score, settings.highscore)
	change_screen($EndScreen)

func update_score(value):
	$PlayScreen.update_score(value)

func show_message(text):
	$PlayScreen.show_message(text)

func _on_TitleScreen_play():
	change_screen($PlayScreen)
	emit_signal('start_game')

func _on_TitleScreen_settings():
	if settings.enable_sound:
		$TransitionSound.play()
	change_screen($SettingsScreen)

func _on_SettingsScreen_return_to_title():
	if settings.enable_sound:
		$TransitionSound.play()
	change_screen($TitleScreen)

func _on_EndScreen_home():
	if settings.enable_sound:
		$TransitionSound.play()
	change_screen($TitleScreen)

func _on_EndScreen_replay():
	change_screen($PlayScreen)
	emit_signal('start_game')
