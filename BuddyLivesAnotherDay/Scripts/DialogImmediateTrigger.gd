extends Area2D
#
export var timeline := String()
var hasTriggered = false

signal dialog_entered(timeline)

func _ready():
	add_to_group("DialogImmediateTriggers")
	var manager = get_node("/root/Main/ViewportContainer2/Overworld/DialogManager")
	var _e = connect("dialog_entered", manager, "_on_NPC_dialog_entered")
	_e = manager.connect("dialog_end", self, "dialog_end")

func _on_Area2D_body_entered(_body):
	print("Triggering dialogue....")
	if !hasTriggered:
		emit_signal("dialog_entered", timeline, self)
	hasTriggered = true	

func dialog_end(_initiator):
	pass
