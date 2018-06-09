extends Area2D

signal capture
signal explode

enum Modes {STATIC, LIMITED, SHRINKING}

var radius = 100
var rot_speed = PI
var num_orbits = 3

var mode = Modes.STATIC setget set_mode
var moving = false setget set_moving
var start_x
var move_dir
var move_speed = 100
var color
var rot = 0
var orbits = 0
var start = 0
var player = null

onready var orbit_pos = $Pivot/ContactPoint

func _ready():
	$Sprite.material = $Sprite.material.duplicate()
	$Sprite2.material = $Sprite.material
	$Pivot/ContactPoint.position.x = radius + 15
	var shape = CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape
	update()

func set_moving(val):
	moving = val
	if val:
		start_x = position.x
		move_dir = pow(-1.0, randi() % 2)

func set_mode(_mode):
	mode = _mode
	match mode:
		Modes.STATIC:
			color = settings.theme['circle_static']
			$Label.hide()
		Modes.LIMITED:
			color =  settings.theme['circle_limited']
			$Label.show()
			orbits = num_orbits
			$Label.text = str(orbits)
#		Modes.SHRINKING:
#			color = settings.theme['circle_shrink']
#			$Label.hide()
	$Sprite.material.set_shader_param('color', color)
	update()

func _draw():
	#draw_circle(Vector2(), radius, Color(.5, .5, .5))
	match mode:
		Modes.LIMITED:
			var r = ((radius-50)/num_orbits) * (1 + num_orbits - orbits)
			draw_circle_arc_poly(Vector2(), r+10, start+PI/2, $Pivot.rotation+PI/2, settings.theme['circle_fill'])

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points+1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func check_orbits():
	if abs($Pivot.rotation - start) > 2*PI:
		orbits -= 1
		if settings.enable_sound:
			$OrbitSound.play()
		$Label.text = str(orbits)
		if orbits <= 0:
			player.target = null
			player.explode()
			explode()
		start = $Pivot.rotation

func _physics_process(delta):
	$Pivot.rotation += rot * delta
	if mode == Modes.LIMITED:
		check_orbits()
	if moving:
		position.x += move_speed * move_dir * delta
		if abs(position.x - start_x) > 100:
			move_dir *= -1
	update()

func _on_Circle_body_entered(body):
	if settings.enable_sound:
		$CaptureSound.play()
	emit_signal('capture', self)
	$AnimationPlayer.play('capture')
	body.capture(self)
	#body.target = self
	player = body
	$Pivot.rotation = (body.position - position).angle()
	start = $Pivot.rotation
	rot = rot_speed * pow(-1.0, randi() % 2)

func explode():
	if settings.enable_sound:
		$ExplodeSound.play()
	emit_signal('explode')
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play('explode')
	yield($AnimationPlayer, 'animation_finished')
	queue_free()