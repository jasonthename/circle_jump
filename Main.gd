extends Node

signal game_over
signal update_score
signal show_message

var Circle = preload("res://Circle.tscn")
var Player = preload("res://Player.tscn")

export var circles_per_level = 8
var score = -1
var level = 1
var player

func _ready():
	randomize()

func new_game():
	yield(get_tree().create_timer(0.5), 'timeout')
	$Camera2D.position = $StartPosition.global_position
	yield(get_tree().create_timer(0.5), 'timeout')
	spawn_circle($StartPosition.global_position, 0)
	player = Player.instance()
	player.position = $StartPosition.global_position
	add_child(player)
	player.connect('dead', self, "_on_Player_dead")
	player.show()
	emit_signal('show_message', 'Go!')
	score = -1
	level = 1
	emit_signal('update_score', score)
	player.can_jump = true

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
		if rand_range(0, 1) > 0.5:
			c.mode = 0
		else:
			if level < 4:
				c.num_orbits = randi() % 3 + 3
			elif level < 8:
				c.num_orbits = randi() % 3 + 2
			elif level < 12:
				c.num_orbits = randi() % 3 + 1
			c.rot_speed = rand_range(PI, 1.5 * PI)
			c.mode = 1
	c.connect('explode', self, '_on_Circle_explode')
	c.connect('capture', self, '_on_Circle_capture')

func _on_Circle_capture(object):
	$Camera2D.position = object.position
	spawn_circle()
	score += 1
	if score > 0 and score % circles_per_level == 0:
		level += 1
		# $HUD.show_message('Level %s' % str(level))
		emit_signal('show_message', 'Level %s' % str(level))
	#$HUD.update_score(score)
	emit_signal('update_score', score)

func _on_Circle_explode():
	pass

func _on_Player_dead():
	for node in $Circles.get_children():
		node.explode()
	$Display.game_over()