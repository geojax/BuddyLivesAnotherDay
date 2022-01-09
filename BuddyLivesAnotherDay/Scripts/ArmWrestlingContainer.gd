extends ViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal wrestleEnd(state)

# Called when the node enters the scene tree for the first time.
func _ready():
	var _e = $Viewport/ArmWrestling.connect("defeat", self, "_on_ArmWrestling_Defeat")
	_e = $Viewport/ArmWrestling.connect("victory", self, "_on_ArmWrestling_Victory")
	rect_position.y = -2000
	rect_position.x = 0
	pass # Replace with function body.

func enterScreen():
	rect_position.y = 0
	$Viewport/ArmWrestling.start()

func exitScreen():
	rect_position.y = -2000
	$Viewport/ArmWrestling.ExitScreen()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DialogManager_wrestle():
	enterScreen()
	pass # Replace with function body.

func _on_ArmWrestling_Defeat():
	exitScreen()
	emit_signal("wrestleEnd", "defeat")

func _on_ArmWrestling_Victory():
	exitScreen()
	emit_signal("wrestleEnd", "victory")
