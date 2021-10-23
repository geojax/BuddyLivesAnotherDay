extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$ProgressBar.value = 50
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ProgressBar.value -= .5
	if Input.is_action_just_pressed("arm_wrestle_push"):
		$ProgressBar.value += 5
		pass
	pass
