extends Node2D

export var timeline := String()
var hasTriggered = false

func _on_Area2D_body_entered(_body):
	print("Triggering dialogue....")
	if !hasTriggered:
		var dialog = Dialogic.start(timeline)
		dialog.connect("timeline_end", self, "_dialog_listener")
		add_child(dialog)
	hasTriggered = true	
	pass # Replace with function body.
