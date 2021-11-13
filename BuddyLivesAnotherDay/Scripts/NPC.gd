extends StaticBody2D

export var timeline := "test-timeline"
export var sprite_frames: SpriteFrames

func _ready():
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$AnimatedSprite.frames = sprite_frames

func _process(delta):
	if !$NearPrompt.in_dialog && Input.is_action_just_pressed("ui_accept") && $NearPrompt.entered:
		$NearPrompt.body_exit("Player")
		$NearPrompt.in_dialog = true
		var dialog = Dialogic.start(timeline)
		dialog.connect("timeline_end", self, "_dialog_listener")
		add_child(dialog)

func _dialog_listener(string):
	$Timer.start()

func _on_Timer_timeout():
	$NearPrompt.in_dialog = false
	$NearPrompt.body_exit("Player")
