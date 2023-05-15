extends RigidBody2D

var type = "iron"
var sprite = "res://Assets/Placeholders/mineral-deposit-hanging.png"
var go = false
var pos

onready var player = get_parent().get_node("Player")

func _ready():
	get_node("Sprite").texture = load(sprite)
	var random = RandomNumberGenerator.new()
	random.randomize()
	var liny = random.randi_range(320,400)
	var linx = random.randi_range(-120,120)
	print(linx)
	linear_velocity = Vector2(linx,-liny)
	angular_velocity = 30

#func _physics_process(_delta):
#	if go:
#		pos = player.get_node("Camera/FuelLabel").rect_position
#		add_central_force(Vector2(1183,-300))

func loot():
	#go = true
	queue_free()
