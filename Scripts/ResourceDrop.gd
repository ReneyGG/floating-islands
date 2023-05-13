extends KinematicBody2D

var type = "iron"
var sprite = "res://Assets/Placeholders/mineral-deposit-hanging.png"

func _read():
	get_node("Sprite").texture = load(sprite)

func loot():
	queue_free()
