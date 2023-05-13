extends Area2D

export var size = 2
onready var health = size
export var toughness = 1

func _on_MineralDeposit_area_entered(body):
	if body.is_in_group("MiningLaserBolt") and body.power >= toughness:
		health -= 1
		if health == 0:
			queue_free()
