extends Node

var Circle = preload("res://Circle.tscn")

export var circles_per_level = 8
var score = -1
var level = 1

func _ready():
	randomize()
	$HUD.show_message('Go!')

func spawn_circle():
	var c = Circle.instance()
	var x = $Player.position.x + rand_range(-100, 100)
	var y = $Player.position.y - rand_range(400, 600)
	c.position = Vector2(x, y)
	add_child(c)
	if rand_range(0, 1) > 0.5:
		c.mode = 0
	else:
		c.num_orbits = randi() % 4 + 1
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
		$HUD.show_message('Level %s' % str(level))
		printt('level', level)
	$HUD.update_score(score)

func _on_Circle_explode():
	pass

func _on_Player_dead():
	$HUD.show_message('Game Over')
#	get_tree().reload_current_scene()
