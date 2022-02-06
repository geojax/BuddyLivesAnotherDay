extends Node

#var player
#var initiator
var wrestling := false

signal wrestle
signal dialog_end
signal dialog_entered
	
func _on_NPC_dialog_entered(timeline:String):
	emit_signal("dialog_entered")
	print("dialog called: "+ timeline)
	var dialog = Dialogic.start(timeline)
	dialog.connect("dialogic_signal", self, "_on_Dialog_dialogic_signal")
	dialog.connect("timeline_end", self, "_on_Timeline_End")
	add_child(dialog)
	
func _on_Dialog_dialogic_signal(string:String):
	if string == "wrestle":
		emit_signal("wrestle")
		wrestling = true
	print(string)

func _on_Timeline_End(timeline):
	if wrestling == false:
		emit_signal("dialog_end")
	
func _on_ViewportContainer_wrestleEnd(state):
	wrestling = false
	emit_signal("dialog_end")


func _on_DialogImmediateTrigger_dialog_entered(timeline):
	_on_NPC_dialog_entered(timeline)
