extends KinematicBody2D

signal dead

export var jump = 1000
export var trail_length = 25

var body_color = settings.theme['player_body']
var trail_color = settings.theme['player_trail']
var velocity = Vector2(100, 0)
var target = null
var can_jump = false

onready var trail = $Trail/Trail

func _ready():
	trail.points = PoolVector2Array()
	$Sprite.material.set_shader_param('color', body_color)
	$Trail/Trail.gradient.set_color(1, trail_color)
	trail_color.a = 0
	$Trail/Trail.gradient.set_color(0, trail_color)

func _input(event):
	if can_jump and event is InputEventScreenTouch and event.pressed:
		launch()

func capture(_target):
	can_jump = true
	target = _target
	velocity = Vector2()

func launch():

	can_jump = false
	target.explode()
	target = null
	velocity = Vector2(jump, 0).rotated(rotation)

func _physics_process(delta):
	if target:
		position = target.orbit_pos.global_position
		rotation = (position - target.position).angle()
	else:
		move_and_collide(velocity * delta)
	if trail.points.size() > trail_length:
		trail.remove_point(0)
	trail.add_point(position)

func explode():
	can_jump = false
	emit_signal('dead')
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	explode()
