extends Node

func _ready():
	if !OS.has_feature("web"):
		# OS.window_fullscreen = true
		var size = OS.get_screen_size()
		var padding = Vector2(size.x / 8, size.x / 8)
		OS.window_size = size - padding
		OS.center_window()

func _process(_delta):
	if !OS.has_feature("web"):
		if Input.is_action_just_pressed("toggleFullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen
