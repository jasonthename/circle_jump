extends Area2D

signal capture

export var rot_speed = PI/2
var rot = 0
var orbits = 0
var start = 0

onready var orbit_pos = $Pivot/Position2D

func _process(delta):
	$Pivot.rotation += rot * delta
	if abs($Pivot.rotation - start) > 2*PI:
		orbits += 1
		print(orbits)
		start = $Pivot.rotation

func _on_Planet_body_entered(body):
	emit_signal('capture', self)
	body.target = self
	$Pivot.rotation = (body.position - position).angle()
	start = $Pivot.rotation
	orbits = 0
	body.velocity = Vector2()
	rot = rot_speed * pow(-1.0, randi() % 2)

func explode():
	queue_free()