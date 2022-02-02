class_name RoomData
extends Node
## OKOK I am SO sorry for the horrible class name
# you tell me what you would've done ok
# RoomDataForNPC ? Really?
# I am stuck here, so...
# this is the last I've got.

var roomName: String
var present:bool = false
var pos:Vector2
func _init(newroomName:String, newPos:=Vector2(), isPresent=true):
	roomName = newroomName
	pos=newPos
	present = isPresent
func _ready():
	pass
