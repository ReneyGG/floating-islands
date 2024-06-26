extends KinematicBody2D

var velocity = Vector2.ZERO
export var drift_speed = 0
export var island_value = 0

func _ready():
	pass

func _physics_process(delta):
	if drift_speed >= 0:
		global_position = global_position.move_toward(Vector2(3000,global_position.y), delta * drift_speed)
	else:
		global_position = global_position.move_toward(Vector2(-3000,global_position.y), delta * (drift_speed * -1))
