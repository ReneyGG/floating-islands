extends KinematicBody2D

export var gravity = 60
export var acceleration = 2200
export var deacceleration = 5000
export var max_speed = 700
export var friction = 2400
export var jump_height = 1300

onready var sprite = get_node("Sprite")
onready var timer = get_node("Timer")

var jump_count
var motion = Vector2()
var hSpeed = 0
var air = false

func _ready():
	timer.wait_time = 0.1
	timer.one_shot = true

func movement(var delta):
	if Input.is_action_pressed("ui_right"):
		if(hSpeed <-100):
			hSpeed += (deacceleration * delta)
		elif(hSpeed < max_speed):
			hSpeed += (acceleration * delta)
			sprite.flip_h = false
		else:
			pass
	elif Input.is_action_pressed("ui_left"):
		if(hSpeed > 100):
			hSpeed -= (deacceleration * delta)
		elif(hSpeed > -max_speed):
			hSpeed -= (acceleration * delta)
			sprite.flip_h = true
		else:
			pass
	else:
		hSpeed -= min(abs(hSpeed), friction * delta) * sign(hSpeed)

func _physics_process(delta):
	motion.y += gravity
	
	movement(delta)
	if !is_on_floor():
		air = true
	if is_on_floor():
		if air:
			sprite.scale = Vector2(1.2, 0.8)
		air = false
		jump_count = 1
	if Input.is_action_just_pressed("ui_up"):
		sprite.scale = Vector2(0.8, 1.2)
		timer.start()

	if timer.get_time_left() > 0.0 and jump_count != 0:
		motion.y = -jump_height
		jump_count-=1
	
	motion.x = hSpeed
	motion = move_and_slide(motion,Vector2(0,-1))
	
	sprite.scale.x = lerp(sprite.scale.x, 1, 0.2)
	sprite.scale.y = lerp(sprite.scale.y, 1, 0.2)
