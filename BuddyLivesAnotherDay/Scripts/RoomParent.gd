#tool
extends Node

export var player_position := Vector2(0,0)

export var left_limit := 0 setget set_left
export var right_limit := 600 setget set_right
export var top_limit := 0 setget set_top
export var bottom_limit := 300 setget set_bottom
export (AudioStream) var footstepSound = load("res://Audio/Buddy Footsteps.wav")
#onready var camera = get_parent().get_parent().get_node("Player").get_node("Camera2D")

func _ready():
	top_limit=$Image/TopLeft.position.y
	bottom_limit=$Image/BottomRight.position.y
	left_limit=$Image/TopLeft.position.x
	right_limit=$Image/BottomRight.position.x
	UpdateLines()		
	get_tree().call_group("NPCs", "enableIfInRoom", name.substr(0,len(name)-5))

func UpdateLines():
	if has_node("Debug"):
		var debug = get_node("Debug")
		debug.EraseLines()
		debug.DrawLine(Vector2(left_limit, top_limit), Vector2(left_limit, bottom_limit), Color.red)
		debug.DrawLine(Vector2(right_limit, top_limit), Vector2(right_limit, bottom_limit), Color.red)
		debug.DrawLine(Vector2(left_limit, top_limit), Vector2(right_limit, top_limit), Color.red)
		debug.DrawLine(Vector2(left_limit, bottom_limit), Vector2(right_limit, bottom_limit), Color.red)
		debug.update()

func set_left(new_left):
	print(new_left)
	if left_limit != new_left:
		left_limit = new_left
		UpdateLines()
func set_right(new_right):
	if right_limit != new_right:
		right_limit = new_right
		UpdateLines()
func set_top(new_top):
	print(new_top)
	if top_limit != new_top:
		top_limit = new_top
		UpdateLines()
func set_bottom(new_bottom):
	if bottom_limit != new_bottom:
		bottom_limit = new_bottom
		UpdateLines()
