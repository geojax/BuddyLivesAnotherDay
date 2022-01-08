extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_NPC_dialog_entered(timeline:String):
	var dialog = Dialogic.start(timeline)
	add_child(dialog)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
