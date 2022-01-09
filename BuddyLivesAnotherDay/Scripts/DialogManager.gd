extends Node

var player
var initiator
var wrestling := false

signal wrestle
signal dialog_end(init)

func _ready():
	player = find_parent("Overworld").find_node("Player")

func _on_NPC_dialog_entered(timeline:String, init:Node):
	initiator = init
	if player == null:
		player = find_parent("Overworld").find_node("Player")
	player.canMove = false
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
		emit_signal("dialog_end", initiator)
	
func _on_ViewportContainer_wrestleEnd(state):
	wrestling = false
	emit_signal("dialog_end", initiator)
