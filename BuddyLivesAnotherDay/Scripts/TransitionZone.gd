class_name TransitionZone
extends Area2D

export var toPosition := Vector2(0,0)
export var room: String
export var changeMusic : bool
export var changeMusicTo: AudioStream

var checking := false

onready var overworld = get_tree().root.get_child(0).find_node("Overworld")

signal exit(pos, scene)
signal newmusic(music)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _e = connect("body_entered", self, "_on_body_entered")
	_e = $Timer.connect("timeout", self, "_on_Timer_timeout")
	if overworld == null:
		overworld = get_tree().root.get_child(0).find_node("Overworld")
	if overworld == null:
		overworld = get_tree().root.get_child(0)
	_e = connect("exit", overworld, "_on_TransitionZone_entered")
	connect("newmusic", overworld, "_on_TransitionZone_music_changed")

func _on_body_entered(body) -> void:
	if checking && body && body.name && body.name == "Player":
		emit_signal("exit", toPosition, room)
		if changeMusic:
			emit_signal("newmusic", changeMusicTo)

func _on_Timer_timeout() -> void:
	checking = true
