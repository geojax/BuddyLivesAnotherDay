extends KinematicBody2D

enum MovementState{
	IDLE,
	UP,
	LEFT,
	DOWN,
	RIGHT
}

export var canMove = true
export var canMoveVert = true
var state = MovementState.IDLE
var velocity := Vector2()

const MOVE_SPEED := 100


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
	if canMoveVert:
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
	match state:
		MovementState.IDLE:
			$AnimatedSprite.stop()
		MovementState.UP:
			$AnimatedSprite.play("WalkUp")
			$AnimatedSprite.scale = Vector2(0.285,0.285)
		MovementState.DOWN:
			$AnimatedSprite.play("WalkDown")
			$AnimatedSprite.scale = Vector2.ONE		
		MovementState.LEFT:
			$AnimatedSprite.play("WalkLeft")
			$AnimatedSprite.scale = Vector2.ONE
			
			$AnimatedSprite.flip_h = false
		MovementState.RIGHT:
			$AnimatedSprite.play("WalkRight")
			$AnimatedSprite.scale = Vector2.ONE
			
			$AnimatedSprite.flip_h = true

func _process(_delta: float) -> void:
	UpdateDirection()
	UpdateAnimation()
	if state == MovementState.IDLE:
		$Footsteps.stop()
	elif $Footsteps.playing == false:
		$Footsteps.play()

func _physics_process(_delta: float) -> void:
	if canMove:
		velocity = move_and_slide(GetVelocity())
