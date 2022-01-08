extends Node

signal wrestle

func _on_NPC_dialog_entered(timeline:String):
	var dialog = Dialogic.start(timeline)
	dialog.connect("dialogic_signal", self, "_on_Dialog_dialogic_signal")
	add_child(dialog)
	
func _on_Dialog_dialogic_signal(string):
	if string == "wrestle":
		emit_signal("wrestle")
