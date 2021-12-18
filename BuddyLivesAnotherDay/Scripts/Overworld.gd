extends Node

export var initialRoom := "West-One"

const room_path = "res://Scenes/Rooms/"

var setpos
var timer
var setscene

signal load_room (room)

func _ready():
	start()
	
func start():
	var _e = connect("load_room", self, "_on_Load_Room")
	emit_signal("load_room", initialRoom, true)
	
	create_timer(1.7, "_on_enter_timeout")
	$ScreenEffects.PlayEnter()
	$PlayContainer/Player.canMove = false
	
func _on_Load_Room (room, start):
	var path = room_path + room + ".tscn"
	var new_room = load(path).instance()
	
	set_camera_limits(new_room)
	if start:
		$PlayContainer/Player.position = new_room.player_position
	
	if $PlayContainer/RoomContainer.get_child_count() != 0:
		var child = $PlayContainer/RoomContainer.get_child(0)
		$PlayContainer/RoomContainer.remove_child(child)
		
	$PlayContainer/RoomContainer.add_child(new_room)

func _on_TransitionZone_entered(pos, scene):
	$ScreenEffects.PlayExit()
	$PlayContainer/Player.canMove = false
	create_timer(1.7, "_on_exit_timeout")
	
	setpos = pos
	setscene = scene

func create_timer(time, function):
	timer = Timer.new()
	
	timer.set_wait_time(time)
	timer.one_shot = true
	timer.connect("timeout",self, function)
	add_child(timer) #to process
	
	timer.start() #to start

func set_camera_limits(room):
	var camera = $PlayContainer/Player.get_node("Camera2D")
	camera.limit_left =  room.left_limit
	camera.limit_right =  room.right_limit
	camera.limit_top =  room.top_limit
	camera.limit_bottom =  room.bottom_limit
	
func _on_exit_timeout():
	timer.queue_free()
	create_timer(1.7, "_on_enter_timeout")
	$ScreenEffects.PlayEnter()
	$PlayContainer/Player.position = setpos
	call_deferred("_on_Load_Room", setscene, false)

func _on_enter_timeout():
	timer.queue_free()
	$PlayContainer/Player.canMove = true
