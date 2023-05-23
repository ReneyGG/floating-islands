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
var deposit = false

var pocket = {"floatstone":15,"aetheric_iron":0,"celestium":0,"azulite":0,"sky_ruby":0}
var hub = {"floatstone":0,"aetheric_iron":0,"celestium":0,"azulite":0,"sky_ruby":0}

onready var sprite = get_node("Sprite")
onready var jump_timer = get_node("JumpTimer")
onready var fuel_label = get_node("Camera/FuelLabel")
onready var equip_load = get_node("Camera/TextureProgress")
onready var upgrade = get_node("UpgradeMenu")

func _ready():
	jetpack_fuel = jetpack_maxfuel
	jump_timer.wait_time = 0.15
	jump_timer.one_shot = true
	fuel_label.text = "Fuel: "+str(jetpack_fuel)

func _unhandled_input(event):
	if event.is_action_pressed("upgrade"):
		upgrade.visible = !upgrade.visible

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
	if upgrade.visible:
		return
	
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
	if Input.is_action_just_pressed("drop") and !air:
		position.y += 1
	
	if Input.is_action_pressed("interact"):
		if deposit and equip_load.value > 0:
			equip_load.value -= 1
			for m in pocket:
				if pocket[m] > 0:
					pocket[m] -= 1
					hub[m] += 1
					break
	
	if jump_timer.get_time_left() > 0.0:
		motion.y = -jump_height
		jump_count-=1
	
	if is_on_floor():
		var collider = get_slide_collision(0).collider
		if collider.is_in_group("island"):
			self.z_index = collider.z_index + 1
	
	motion.x = hSpeed
	motion = move_and_slide(motion,Vector2(0,-1))
	
	sprite.scale.x = lerp(sprite.scale.x, 1, 0.2)
	sprite.scale.y = lerp(sprite.scale.y, 1, 0.2)

func die():
	motion.y = 0
	self.global_position = Vector2(0,-200)

func _on_LootRange_body_entered(body):
	if body.is_in_group("resource") and equip_load.value < 15:
		body.loot()

func add_load(ore):
		equip_load.value += 1
		pocket[ore] += 1

func _on_LootRange_area_entered(area):
	if area.name == "DepositPoint":
		deposit = true

func _on_LootRange_area_exited(area):
	deposit = false
