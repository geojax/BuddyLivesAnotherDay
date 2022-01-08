extends ViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rect_position.y = -2000
	rect_position.x = 0
	pass # Replace with function body.

func enterScreen():
	rect_position.y = 0

func exitScreen():
	rect_position.y = -2000
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DialogManager_wrestle():
	enterScreen()
	pass # Replace with function body.
