extends Node2D

# The projectile that the laser fires.
export var projectile: Resource

# The number of projectiles the laser can fire before needing to recharge
export var max_laser_charge = 6
onready var laser_charge = max_laser_charge

# The time between shots
onready var firing_interval = get_node("FiringInterval")
# The time it takes to regain one laser charge
onready var recharge_time = get_node("RechargeTime")
# The wait between firing the last bolt and your lasers starting to recharge.
onready var recharge_wait = get_node("RechargeWait")

onready var charge_label = get_node("ChargeLabel")

func _physics_process(_delta):
	
	if Input.is_action_pressed("shoot"):
		if firing_interval.is_stopped() and laser_charge > 0:
			
			_fire_laser()
			_alter_laser_charge(-1)
			
			# Reset both the timers. For some reason to reset a timer you have to do stop then start.
			firing_interval.stop()
			firing_interval.start()
			
			recharge_wait.stop()
			recharge_wait.start()
			
			# Also need to stop this timer or else you'll end up with multiple "recharges" going on at once.
			recharge_time.stop()

func _fire_laser():
	var new_laser = projectile.instance()
	get_tree().current_scene.add_child(new_laser)
	new_laser.trajectory = get_local_mouse_position().normalized()
	new_laser.look_at(get_local_mouse_position())
	new_laser.global_position = global_position

func _alter_laser_charge(amount):
	# Alters laser charge by an amount. Ensures the charge doesn't go below 0 or above max.
	laser_charge = clamp(laser_charge + amount, 0, max_laser_charge)
	charge_label.set_text("Charge: " + str(laser_charge))

func _on_RechargeWait_timeout():
	# After not firing for a peroid of time, start regaining spent laser charges.
	recharge_time.start()

func _on_RechargeTime_timeout():
	# Add 1 laser charge and restart the recharge timer.
	if laser_charge < max_laser_charge:
		_alter_laser_charge(1)
		recharge_time.start()
