extends Node2D

# The maximum height above the origin that islands can spawn at.
export var maxheight = 0

# The minimum depth below the origin that islands can spawn at.
export var minheight = 0

# An array of packed scenes which the spawner selects from randomly when picking new islands to spawn.
# This will allow us to easily add new varieties of island later on.
export (Array, Resource) var possible_islands

var rng = RandomNumberGenerator.new()
onready var spawn_timer = get_node("IslandSpawnTimer")

func _ready():
	rng.randomize()

func _on_IslandSpawnTimer_timeout():
	# Generate a new island at a random altitude and give it a random drift speed.
	var new_island = possible_islands[rng.randi() % len(possible_islands)].instance()
	new_island.drift_speed = -rng.randf_range(40.0, 60.0)
	new_island.position = Vector2(0, rng.randi_range(maxheight, minheight))
	add_child(new_island)
	
	# Set the timer to spawn a new island a random number of seconds later.
	spawn_timer.set_wait_time(rng.randi_range(10, 20))
