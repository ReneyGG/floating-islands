extends Control

onready var player = get_parent()

var dict = {"floatstone":0,"aetheric_iron":0,"celestium":0,"azulite":0,"sky_ruby":0}

func _ready():
	self.hide()

func _on_Button_pressed():
	dict["floatstone"] = int(get_node("Floatstone").text)
	dict["aetheric_iron"] = int(get_node("AethericIron").text)
	dict["celestium"] = int(get_node("Celestium").text)
	dict["azulite"] = int(get_node("Azulite").text)
	dict["sky_ruby"] = int(get_node("SkyRuby").text)
	
	for a in player.hub:
		if player.hub[a] < dict[a]:
			print("not enough resources")
			return
	
	for b in player.hub:
		player.hub[b] -= dict[b]
	self.hide()
