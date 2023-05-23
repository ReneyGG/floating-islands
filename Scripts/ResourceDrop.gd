extends RigidBody2D

var type = "iron"
#var sprite = "res://Assets/Placeholders/mineral-deposit-hanging.png"
var go = false
var pos
var end = false

onready var player = get_parent().get_node("Player")

func _ready():
	#get_node("Sprite").texture = load(sprite)
	var random = RandomNumberGenerator.new()
	random.randomize()
	var liny = random.randi_range(320,400)
	var linx = random.randi_range(-120,120)
	linear_velocity = Vector2(linx,-liny)
	angular_velocity = 30

func _physics_process(_delta):
	if go:
		pos = player.global_position - self.global_position + Vector2(0,-80)
		add_central_force(pos)
		if !end:
			end = true
			get_node("Timer").start()

func loot():
	go = true

func _on_Timer_timeout():
	player.add_load()
	queue_free()
