extends KinematicBody2D

var velocity = Vector2.ZERO
export var drift_speed = 0

func _ready():
	velocity.x += drift_speed

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
