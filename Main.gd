extends Node

signal game_over
signal update_score
signal show_message

var Circle = preload("res://Circle2.tscn")
var Player = preload("res://Player.tscn")
var score_file = "user://highscore.txt"

var circles_per_level = 5
var score = 0
var level = 1
var player
var enable_sound = true
var enable_music = true

func _ready():
	randomize()
	$CanvasLayer/Background.color = settings.theme['background']

func new_game():
	yield(get_tree().create_timer(0.5), 'timeout')
	$Camera2D.position = $StartPosition.global_position
	spawn_circle($StartPosition.global_position, 0)
	yield(get_tree().create_timer(0.5), 'timeout')
	player = Player.instance()
	player.position = $StartPosition.global_position - Vector2(100, 0)
	add_child(player)
	player.connect('dead', self, "_on_Player_dead")
	emit_signal('show_message', 'Go!')
	score = -1
	level = 1
	emit_signal('update_score', score)
	player.can_jump = true
	if settings.enable_music:
		$Music.play()

func spawn_circle(_position=null, _type=null):
	var c = Circle.instance()
	if _position:
		c.position = _position
	else:
		var x = player.position.x + rand_range(-100, 100)
		var y = player.position.y - rand_range(425, 550)
		c.position = Vector2(x, y)
	$Circles.add_child(c)
	if _type != null:
		c.mode = _type
	else:
		if rand_range(0, 1) > 0.5 or level == 1:
			c.mode = 0
		else:
			if level < 4:
				c.num_orbits = randi() % 3 + 3
			elif level < 8:
				c.num_orbits = randi() % 3 + 2
				if rand_range(0, 1) > 0.7:
					c.moving = true
			elif level < 12:
				c.num_orbits = randi() % 3 + 1
				if rand_range(0, 1) > 0.5:
					c.moving = true
			else:
				c.num_orbits = randi() % 2 + 1
				if rand_range(0, 1) > 0.4:
					c.moving = true
			c.mode = 1
	c.rot_speed = rand_range(PI, 1.2 * PI) * (1 + level/10.0)
	c.connect('explode', self, '_on_Circle_explode')
	c.connect('capture', self, '_on_Circle_capture')

func _on_Circle_capture(object):
	$Camera2D.position = object.position
	spawn_circle()
	score += 1
	if score > 0 and score % circles_per_level == 0:
		level += 1
		emit_signal('show_message', 'Level %s' % str(level))
	emit_signal('update_score', score)

func _on_Circle_explode():
	pass

func _on_Player_dead():
	for node in $Circles.get_children():
		node.explode()
	#yield(get_tree().create_timer(0.5), 'timeout')
	if score > settings.highscore:
		settings.highscore = score
		settings.save_score()
	$Display.game_over(score)
	print('called game over')
	$Music.stop()
