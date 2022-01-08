extends StaticBody2D

export var timeline := "test-timeline"
export var sprite_frames: SpriteFrames

var player
var encounters
func _ready():
	var _e = $Timer.connect("timeout", self, "_on_Timer_timeout")
#	$AnimatedSprite.frames = sprite_frames

func _process(_delta):
	if !$NearPrompt.in_dialog && Input.is_action_just_pressed("ui_accept") && $NearPrompt.entered:
		if player == null:
			player = find_parent("Overworld").find_node("Player")
		if player != null:
			player.canMove = false
		$NearPrompt.body_exit("Player")
		$NearPrompt.in_dialog = true
		var dialog = Dialogic.start(timeline)
		dialog.connect("timeline_end", self, "_dialog_listener")
		dialog.connect("dialogic_signal", self, "_on_Dialogic_")
		add_child(dialog)

func _dialog_listener(_string):
	$Timer.start()
	$NearPrompt.get_node("PromptAnim").play("Enter")

func _on_Timer_timeout():
	if player == null:
		player = find_parent("Overworld").find_node("Player")
	if player != null:
		player.canMove = true
	$NearPrompt.in_dialog = false
	$NearPrompt.entered = true
