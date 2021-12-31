extends Node

export var initialRoom := "West-One"

const room_path = "res://Scenes/Rooms/"

var setpos
var timer
var setscene
var baroffset 
var offset
var barL
var barR
var player
var cam_zoom

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
	camera.zoom = room.cam_zoom
	cam_zoom = camera.zoom.x
	offset = ((1920 - 1620) * cam_zoom) / 2
	camera.limit_left = -offset
	camera.limit_right = (bg.texture.get_width()*bg.scale.x) + offset
	camera.limit_top = 0
	camera.limit_bottom = bg.texture.get_height() * bg.scale.y
	baroffset = bg.texture.get_width() * bg.scale.x
	
#	var box = Sprite.new()
#	box.texture = load("res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex")
#	room.add_child(box)
#	box.centered = false
#	box.position.x = -offset*4
#	box.scale.x = camera.limit_right/32
#	box.scale.y = camera.limit_bottom/32
#	box.modulate = Color(0,0,0)
#	box.z_index = -2
	
	player = $PlayContainer.get_node("Player")
	barL = $PlayContainer.get_node("Bars")
	barR = $PlayContainer.get_node("Bars2")
	barL.scale.x = (offset/1450)
	barL.scale.y = 200
	barL.position.y = -300
	barR.scale.x = (offset/1450)
	barR.scale.y = 200
	barR.position.y = -300
	
func updatebars():	
	
	var posChange = player.position.x - (960*cam_zoom)
	barL.position.x = clamp(posChange, -offset, (baroffset-(1620*cam_zoom)-offset))
	var posChange2 = player.position.x + (960*cam_zoom) - offset
	barR.position.x = clamp(posChange2, ((1620*cam_zoom)-(offset/64)), baroffset-(offset/64))

func _process(delta):
	updatebars()
	
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
