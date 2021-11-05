extends StaticBody2D

onready var player := get_node("/root/Overworld/Player")

func _ready():
	$Timer.connect("timeout", self, "_on_Timer_timeout")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && $NearCheck.entered:
		$NearCheck._on_NearCheck_body_exit(player)
		var dialog = Dialogic.start("test-timeline")
		dialog.connect("timeline_end", self, "_dialog_listener")
		add_child(dialog)

func _dialog_listener(string):
	$Timer.start()

func _on_Timer_timeout():
	$NearCheck._on_NearCheck_body_enter(player)
