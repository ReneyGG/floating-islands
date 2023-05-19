extends Node2D

# An array of packed scenes which the spawner selects from randomly when picking new islands to spawn.
# This will allow us to easily add new varieties of island later on.
export (Array, Resource) var possible_islands

export var drift_direction = -1

# A small amount of randomness added to the Y position of the island to make them seem more organic.
export var position_jitter = 500
export var higher_relative_position: bool = false

var rng = RandomNumberGenerator.new()
onready var spawn_timer = get_node("IslandSpawnTimer")

func _ready():
	if higher_relative_position:
		self.z_index = 0
	else:
		self.z_index = 3
	rng.randomize()
	spawn_timer.set_wait_time(1)
	spawn_timer.start()

func _on_IslandSpawnTimer_timeout():
	# Generate a new island with some positional jitter and give it a random drift speed.
	var new_island = possible_islands[rng.randi() % len(possible_islands)].instance()
	new_island.drift_speed = rng.randf_range(60.0, 100.0)*drift_direction
	new_island.position.y += rng.randi_range(-position_jitter, position_jitter)
	new_island.z_index = self.z_index
	add_child(new_island)
	
	_randomize_timer()

func _randomize_timer():
	# Set the timer to spawn a new island a random number of seconds later.
	spawn_timer.set_wait_time(rng.randi_range(20, 60))
	spawn_timer.start()
