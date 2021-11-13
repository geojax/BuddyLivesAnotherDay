extends Area2D

export var toPosition := Vector2(0,0)
export var room: String

var checking := false

onready var overworld = get_node("/root/Overworld")

signal exit(pos, scene)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("exit", overworld, "_on_TransitionZone_entered")
	connect("body_entered", self, "_on_body_entered")
	$Timer.connect("timeout", self, "_on_Timer_timeout")

func _on_body_entered(body) -> void:
	if checking && body && body.name && body.name == "Player":
		emit_signal("exit", toPosition, room)

func _on_Timer_timeout() -> void:
	checking = true
