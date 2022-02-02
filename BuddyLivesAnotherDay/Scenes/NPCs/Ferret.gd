extends "res://Scripts/NPC.gd"


func _ready():
	pass

func _on_Overworld_load_room(roomName, b):
#	encounters += 1
	if encounters > 0:
		setStatusInRoom("West-Two", false)
