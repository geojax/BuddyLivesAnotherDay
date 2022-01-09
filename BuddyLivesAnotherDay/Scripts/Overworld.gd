extends Viewport

export var initialRoom := "West-One"

const room_path = "res://Scenes/Rooms/"

var musicPlayer :AudioStreamPlayer
var ambiencePlayer :AudioStreamPlayer

var setpos
var timer
var setscene
var baroffset 
var offset
var barL : Sprite
var barR : Sprite
var player : KinematicBody2D
var cam_zoom
export var widthBetweenBars := 1620

export var rooms = []

signal load_room (room)

func _ready():
	randomize()
	start()
	player = $PlayContainer/Player	
	$Music.play(25)
	musicPlayer = $Music
	ambiencePlayer = $Ambience
	
func start():
	var _e = connect("load_room", self, "_on_Overworld_load_room")
	emit_signal("load_room", initialRoom, true)
	
	create_timer(1.7, "_on_enter_timeout")
	$EffectContainer/ScreenEffects.PlayEnter()
	$PlayContainer/Player.canMove = false

# Set up room when it has been loaded in:
# - Set camera's limits and zoom
# - Set player's spawn positoin
# - 
func _on_Overworld_load_room (room, start):
	var path = room_path + room + ".tscn"
	var new_room = load(path).instance()
	
	set_camera_limits(new_room)
	if start:
		$PlayContainer/Player.position = new_room.player_position
	
	if $PlayContainer/RoomContainer.get_child_count() != 0:
		var child = $PlayContainer/RoomContainer.get_child(0)
		$PlayContainer/RoomContainer.remove_child(child)
		
	$PlayContainer/RoomContainer.add_child(new_room)
	$PlayContainer/Player.canMoveVert = new_room.playerCanMoveVert

func _on_TransitionZone_entered(pos, scene):
	$EffectContainer/ScreenEffects.PlayExit()
	$PlayContainer/Player.canMove = false
	create_timer(1.7, "_on_exit_timeout")
	
	setpos = pos
	setscene = scene

# Creates a timer with time `time`
# that runs `function` when it times out.
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
	offset = ((1920 - widthBetweenBars) * cam_zoom) / 2
	camera.limit_left = -offset
	camera.limit_right = (bg.texture.get_width()*bg.scale.x) + offset
	camera.limit_top = 0
	camera.limit_bottom = bg.texture.get_height() * bg.scale.y
	baroffset = bg.texture.get_width() * bg.scale.x
	
	barL = $PlayContainer.find_node("Bars")
	barR = $PlayContainer.find_node("Bars2")
	barL.scale.x = (offset/1440)
	barL.scale.y = 200
	barL.position.y = -300
	barR.scale.x = (offset/1440)
	barR.scale.y = 200
	barR.position.y = -300
	
func updatebars():	
	var posChange = player.position.x - (960*cam_zoom)
	barL.position.x = clamp(posChange, -offset, (baroffset-(widthBetweenBars*cam_zoom)-offset))
	var posChange2 = player.position.x + (960*cam_zoom) - offset
	barR.position.x = clamp(posChange2, ((widthBetweenBars*cam_zoom)-(offset/64)), baroffset-(offset/64))

func _process(_delta):
	updatebars()
	
func _on_exit_timeout():
	timer.queue_free()
	create_timer(1.7, "_on_enter_timeout")
	$EffectContainer/ScreenEffects.PlayEnter()
	$PlayContainer/Player.position = setpos
	call_deferred("_on_Overworld_load_room", setscene, false)

func _on_enter_timeout():
	timer.queue_free()
	$PlayContainer/Player.canMove = true

func _on_TransitionZone_music_changed(music):
	#How to fade music?
	$AudioStreamPlayer.stream = music
	$AudioStreamPlayer.play()
	pass
	
func _on_TransitionZone_footsteps_changed(footsteps):
	player.get_node("Footsteps").stream = footsteps

func _on_TransitionZone_ambience_changed(ambience: AudioStream):
	$Ambience.stream = ambience
	$Ambience.play()

# Stop the overworld sound when wrestling.
func _on_DialogManager_wrestle():
	musicPlayer.stop()
	ambiencePlayer.stop()
