extends Area2D

const MOVE_SPEED := 100

func _ready():
	pass

func _process(delta):
	var moveDirection := Vector2()
	if Input.is_action_pressed("worldRight"):
		moveDirection.x += 1
	if Input.is_action_pressed("worldLeft"):
		moveDirection.x -= 1
	if Input.is_action_pressed("worldUp"):
		moveDirection.y -= 1
	if Input.is_action_pressed("worldDown"):
		moveDirection.y += 1
	position += moveDirection.normalized() * MOVE_SPEED * delta
