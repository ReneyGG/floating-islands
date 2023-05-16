extends Area2D

export var size = 10
onready var health = size
export var toughness = 1

func drop_item():
	var item = load("res://Scenes/ResourceDeposits/ResourceDrop.tscn")
	var item_instance = item.instance()
	#item_instance.type = "x"
	#item_instance.sprite = "x"
	item_instance.global_position = self.global_position
	get_parent().get_parent().get_parent().get_parent().add_child(item_instance) #not a fan but if it works it works lmao

func _on_MineralDeposit_area_entered(body):
	if body.is_in_group("MiningLaserBolt") and body.power >= toughness:
		health -= 1
		call_deferred("drop_item")
		if health == 0:
			queue_free()
