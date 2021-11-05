extends Area2D

export var entered := false

onready var animator := get_node("PromptAnim")

func _ready():
	animator.play("Out")
	connect("body_entered", self, "_on_NearCheck_body_enter")
	connect("body_exited", self, "_on_NearCheck_body_exit")

func _on_NearCheck_body_enter(body):
	if body.name == "Player":
		entered = true
		animator.play("Enter")

func _on_NearCheck_body_exit(body):
	if body.name == "Player":
		entered = false
		animator.play("Exit")
