extends Area2D

export var size = 10
onready var health = size
export var toughness = 0
export var resource_drop: Resource

onready var crack_sound = get_node("DepositCrack")
onready var break_sound = get_node("DepositBreak")

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
		crack_sound.play()
		if health == 0:
			break_sound.play()
			hide()
			$DepositCollider.call_deferred("set_disabled", true)
			yield(break_sound, "finished")
			queue_free()
