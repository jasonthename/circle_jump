extends Area2D

signal capture
signal explode()

var colors = {
        'BLUE': Color(.216, .474, .702, 1.0),
        'RED': Color(1.0, .329, .298, 1.0),
        'YELLOW': Color(.867, .91, .247, 1.0),
        'GREEN': Color(.054, .718, .247, 1.0)
}

enum Modes {STATIC, LIMITED, SHRINKING}

var radius = 100
var rot_speed = PI
var num_orbits = 3

var mode = Modes.STATIC setget set_mode
var color = colors['GREEN']
var rot = 0
var orbits = 0
var start = 0
var player = null

onready var orbit_pos = $Pivot/ContactPoint

func _ready():
	$Sprite.material = $Sprite.material.duplicate()
	$Pivot/ContactPoint.position.x = radius + 15
	var shape = CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape
	update()

func set_mode(_mode):
	mode = _mode
	match mode:
		Modes.STATIC:
			color = colors['GREEN']
			$Label.hide()
		Modes.LIMITED:
			color =  colors['YELLOW']
			$Label.show()
			orbits = num_orbits
			$Label.text = str(orbits)
		Modes.SHRINKING:
			color = colors['BLUE']
			$Label.hide()
	$Sprite.material.set_shader_param('color', color)
	update()

func _draw():
	#draw_circle(Vector2(), radius, Color(.5, .5, .5))
	match mode:
		Modes.LIMITED:
			var r = ((radius-50)/num_orbits) * (1 + num_orbits - orbits)
			draw_circle_arc_poly(Vector2(), r+10, start+PI/2, $Pivot.rotation+PI/2, colors['RED'])

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
	update()

func _on_Circle_body_entered(body):
	if settings.enable_sound:
		$CaptureSound.play()
	emit_signal('capture', self)
	body.capture(self)
	#body.target = self
	player = body
	$Pivot.rotation = (body.position - position).angle()
	start = $Pivot.rotation
	#body.velocity = Vector2()
	rot = rot_speed * pow(-1.0, randi() % 2)

func explode():
	if settings.enable_sound:
		$ExplodeSound.play()
	emit_signal('explode')
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play('explode')
	yield($AnimationPlayer, 'animation_finished')
	queue_free()