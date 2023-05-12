extends KinematicBody2D

export var movement_speed = 500
export var velocity = Vector2.ZERO
export var jump_impulse = 750
export var gravity = 20
export var terminal_velocity = 50

func _ready():
	pass

func _physics_process(_delta):
	
	# Handles basic movement.

	if Input.is_action_pressed("move_left"):
		velocity.x = -movement_speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = movement_speed
	else:
		velocity.x = 0
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
			_jump()
	_fall()
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _jump():
	velocity.y -= jump_impulse

func _fall():
	velocity.y += gravity
