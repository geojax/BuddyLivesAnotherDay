extends Node2D

export var timeline := String()
var hasTriggered = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Area2D_body_entered(body):
	print("Triggering dialogue....")
	if !hasTriggered:
		var dialog = Dialogic.start(timeline)
		dialog.connect("timeline_end", self, "_dialog_listener")
		add_child(dialog)
	hasTriggered = true	
	pass # Replace with function body.
