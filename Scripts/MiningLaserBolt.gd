extends Area2D

export var power = 1
export var projectile_speed = 3000
var trajectory = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	position += trajectory*projectile_speed*delta

func _on_MiningLaserBolt_area_entered(area):
	queue_free()

func _on_MiningLaserBolt_body_entered(body):
	queue_free()

func _on_LifeTime_timeout():
	queue_free()
