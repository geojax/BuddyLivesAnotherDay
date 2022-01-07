extends ViewportContainer


# Declare member variables here. Examples:
# var b = "text"

var overworld
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	overworld = $Viewport/Overworld
	player = find_node("Player")
	rect_size.x = get_viewport_rect().size.x
	rect_size.y = get_viewport_rect().size.x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
