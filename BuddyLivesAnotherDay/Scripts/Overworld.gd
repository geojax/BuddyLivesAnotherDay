extends Node

export var initialRoom := "West-One"

const room_path = "res://Scenes/Rooms/"

var setpos
var timer
var setscene

export var rooms = []

signal load_room (room)

func _ready():
	start()
	var dir = Directory.new()
	if dir.open("res://Scenes/Rooms") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print(file_name.substr(0, file_name.length() - 5))
				rooms.append(file_name.substr(0, file_name.length() - 5))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
func start():
	var _e = connect("load_room", self, "_on_Load_Room")
	emit_signal("load_room", initialRoom, true)
	
	create_timer(1.7, "_on_enter_timeout")
	$ScreenEffects.PlayEnter()
	$PlayContainer/Player.canMove = false
	
func _on_Load_Room (room, start):
#func _on_Load_Room (room, start):
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
	var bg :Sprite = room.get_child(0)
	camera.limit_left = 0
	camera.limit_right =  bg.texture.get_width() * bg.scale.x
	print_debug(camera.limit_right)
	camera.limit_top =  0
	camera.limit_bottom =  bg.texture.get_height() * bg.scale.y
	
func _on_exit_timeout():
	timer.queue_free()
	create_timer(1.7, "_on_enter_timeout")
	$ScreenEffects.PlayEnter()
	$PlayContainer/Player.position = setpos
	call_deferred("_on_Load_Room", setscene, false)

func _on_enter_timeout():
	timer.queue_free()
	$PlayContainer/Player.canMove = true

func _on_TransitionZone_music_changed(music):
	#How to fade music?
	$AudioStreamPlayer.stream = music
	$AudioStreamPlayer.play()
	pass
	
func _on_TransitionZone_footsteps_changed(footsteps):
	$Footsteps.stream = footsteps
