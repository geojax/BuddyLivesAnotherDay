extends Area2D

export var entered := false
export var in_dialog := false

onready var animator := get_node("PromptAnim")

func _ready():
	animator.play("Out")
	connect("body_entered", self, "_on_NearCheck_body_enter")
	connect("body_exited", self, "_on_NearCheck_body_exit")

func body_enter(name):
	if name == "Player":
		entered = true
		animator.play("Enter")
		
func body_exit(name):
	if name == "Player":
		entered = false
		animator.play("Exit")
		
func _on_NearCheck_body_enter(body):
	if body && body.name && !in_dialog:
		body_enter(body.name)

func _on_NearCheck_body_exit(body):
	if body && body.name && !in_dialog:
		body_exit(body.name)
