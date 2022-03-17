extends Area2D
#
export var timeline := String()
var hasTriggered = false

signal dialog_entered(timeline)

func _ready():
	add_to_group("DialogImmediateTriggers")

func _on_Area2D_body_entered(_body):
	print("Triggering dialogue....")
	if !hasTriggered:
		emit_signal("dialog_entered", timeline)
	hasTriggered = true	

func dialog_end(_initiator):
	pass


func _on_DialogImmediateTrigger_area_entered(area):
	print("Triggering dialogue....")
	if !hasTriggered:
		emit_signal("dialog_entered", timeline)
	hasTriggered = true	
	pass # Replace with function body.
