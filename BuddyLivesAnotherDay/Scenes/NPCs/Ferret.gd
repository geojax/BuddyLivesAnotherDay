extends "res://Scripts/NPC.gd"


func _ready():
	pass

func _on_Overworld_load_room(room):
	enableIfInRoom(room.name)
	if encounters > 1:
		setStatusInRoom("West-Two", false)
	print("ferret is visible: ", visible)
	if (rooms.has(room.name)):
		encounters+=1
	
