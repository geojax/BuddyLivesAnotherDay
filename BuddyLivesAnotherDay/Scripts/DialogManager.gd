extends Node

#var player
var initiator
var wrestling := false

signal wrestle
signal dialog_end(initiator)
signal dialog_entered
func _ready():
#	player = find_parent("Overworld").find_node("Player")
	#get_tree().call_group("NPCs", "connect", "dialog_entered", self, "_on_NPC_dialog_entered")
	var npcs = get_tree().get_nodes_in_group("NPCs")
	for npc in npcs:
		npc.connect("dialog_entered", self, "_on_NPC_dialog_entered")
	
func _on_NPC_dialog_entered(timeline:String, init:Node):
	emit_signal("dialog_entered")
	print("dialog called: "+ timeline)
	initiator = init
#	if player == null:
#		player = find_parent("Overworld").find_node("Player")
#	player.canMove = false
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

func _on_DialogImmediateTrigger_dialog_entered(timeline):
	var dialog = Dialogic.start(timeline)
	dialog.connect("dialogic_signal", self, "_on_Dialog_dialogic_signal")
	dialog.connect("timeline_end", self, "_on_Timeline_End")
	add_child(dialog)

func _on_Overworld_loaded_room(room):
	var zones = get_tree().get_nodes_in_group("DialogImmediateTriggers")
	for z in zones:
		z.connect("dialog_entered", self, "_on_DialogImmediateTrigger_dialog_entered")
	pass # Replace with function body.
