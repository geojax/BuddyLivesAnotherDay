extends KinematicBody2D

enum MovementState{
	IDLE,
	UP,
	LEFT,
	DOWN,
	RIGHT
}

export var canMove = true

var state = MovementState.IDLE
var velocity := Vector2()

const MOVE_SPEED := 200


func _ready() -> void:
	# var new_dialog = Dialogic.start('test-timeline')
	# add_child(new_dialog)
	$AnimatedSprite.play("Idle");

func GetVelocity() -> Vector2:
	var moveDirection := Vector2()
	if Input.is_action_pressed("worldRight"):
		moveDirection.x += 1
	if Input.is_action_pressed("worldLeft"):
		moveDirection.x -= 1
	if Input.is_action_pressed("worldUp"):
		moveDirection.y -= 1
	if Input.is_action_pressed("worldDown"):
		moveDirection.y += 1
	return moveDirection.normalized() * MOVE_SPEED

func UpdateDirection() -> void:
	state = MovementState.IDLE
	if Input.is_action_pressed("worldRight"):
		state = MovementState.RIGHT
	if Input.is_action_pressed("worldLeft"):
		state = MovementState.LEFT
	if Input.is_action_pressed("worldUp"):
		state = MovementState.UP
	if Input.is_action_pressed("worldDown"):
		state = MovementState.DOWN

func UpdateAnimation() -> void:
	var animation := "Idle"
	match state:
		MovementState.IDLE:
			animation = "Idle"
		MovementState.UP:
			animation = "WalkUp"
		MovementState.DOWN:
			animation = "WalkDown"
		MovementState.LEFT:
			animation = "WalkLeft"
		MovementState.RIGHT:
			animation = "WalkRight"
	if !canMove:
		animation = "Idle"
	$AnimatedSprite.play(animation)

func _process(_delta: float) -> void:
	UpdateDirection()
	UpdateAnimation()

func _physics_process(_delta: float) -> void:
	if canMove:
		velocity = move_and_slide(GetVelocity())
