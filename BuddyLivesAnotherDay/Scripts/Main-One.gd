extends "res://Scripts/Room.gd"

func _ready():
	var musicPlayer:AudioStreamPlayer = get_node("/root/Main/ViewportContainer2/Overworld/Music")
	$AudioStreamPlayer2D.play(musicPlayer.get_playback_position())
	
