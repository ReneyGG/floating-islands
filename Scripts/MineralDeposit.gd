extends Area2D

export var size = 10
onready var health = size
export var toughness = 0
export var resource_drop: Resource

func _ready():
	connect("area_entered", self, "_on_area_entered")

func drop_item():
	var item_instance = resource_drop.instance()
	#item_instance.type = "x"
	#item_instance.sprite = "x"
	item_instance.global_position = self.global_position
	get_node("/root/Main").add_child(item_instance)

func _on_area_entered(body):
	if body.is_in_group("MiningLaserBolt") and body.power >= toughness:
		health -= 1
		call_deferred("drop_item")
		if health == 0:
			queue_free()
