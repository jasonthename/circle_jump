extends KinematicBody2D

signal dead

export var jump = 1000
export var trail_length = 25

var velocity = Vector2(100, 0)
var target = null
var can_jump = false

onready var trail = $Trail/Trail

func _ready():
	trail.points = PoolVector2Array([position])
	$AnimationPlayer.play('capture')

func _input(event):
	if can_jump and target and event is InputEventScreenTouch and event.pressed:
		launch()

func capture(_target):
	target = _target
	velocity = Vector2()
	$AnimationPlayer.play('capture')

func launch():
	#target.rot = 0
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
	emit_signal('dead')
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	explode()