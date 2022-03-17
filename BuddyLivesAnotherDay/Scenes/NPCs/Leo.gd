extends "res://Scripts/NPC.gd"


func _ready():
	if encounters > 5:
		setStatusInRoom("West-Two", false)
	pass
