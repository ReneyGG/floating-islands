extends KinematicBody2D

export var gravity = 60
export var acceleration = 2000
export var deacceleration = 5000
export var max_speed = 600
export var friction = 2400
export var jump_height = 1000
export var jetpack_power = 400
export var jetpack_maxfuel = 100

var jetpack_fuel
var jump_count
var motion = Vector2()
var hSpeed = 0
var air = false

onready var sprite = get_node("Sprite")
onready var jump_timer = get_node("JumpTimer")
onready var fuel_label = get_node("Camera/FuelLabel")

func _ready():
	jetpack_fuel = jetpack_maxfuel
	jump_timer.wait_time = 0.1
	jump_timer.one_shot = true
	fuel_label.text = "Fuel: "+str(jetpack_fuel)

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
		jetpack_fuel = int(clamp(jetpack_fuel+1, 0, jetpack_maxfuel))
		fuel_label.text = "Fuel: "+str(jetpack_fuel)
	if Input.is_action_just_pressed("ui_up") and jump_count != 0 and !air:
		sprite.scale = Vector2(0.8, 1.2)
		jump_timer.start()
	if Input.is_action_pressed("jetpack") and jetpack_fuel > 0:
		sprite.scale = Vector2(0.8, 1.2)
		motion.y = -jetpack_power
		jetpack_fuel -= 1
		fuel_label.text = "Fuel: "+str(jetpack_fuel)
	
	if jump_timer.get_time_left() > 0.0:
		motion.y = -jump_height
		jump_count-=1
	
	motion.x = hSpeed
	motion = move_and_slide(motion,Vector2(0,-1))
	
	sprite.scale.x = lerp(sprite.scale.x, 1, 0.2)
	sprite.scale.y = lerp(sprite.scale.y, 1, 0.2)
