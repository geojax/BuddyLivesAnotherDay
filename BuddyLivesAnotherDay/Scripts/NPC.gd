extends StaticBody2D

export var timeline := "test-timeline"
export var spriteFrames: SpriteFrames

onready var player := get_node("Player")

func _ready():
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$AnimatedSprite.frames = spriteFrames

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && $NearPrompt.entered:
		$NearPrompt._on_NearCheck_body_exit(player)
		$NearPrompt.in_dialog = true
		var dialog = Dialogic.start(timeline)
		dialog.connect("timeline_end", self, "_dialog_listener")
		add_child(dialog)

func _dialog_listener(string):
	$Timer.start()

func _on_Timer_timeout():
	$NearPrompt.in_dialog = false
	$NearPrompt._on_NearCheck_body_enter(player)
