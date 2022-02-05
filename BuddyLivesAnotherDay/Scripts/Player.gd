class_name Player
extends KinematicBody2D

enum MovementState{
	IDLE,
	UP,
	LEFT,
	DOWN,
	RIGHT,
	SIDESCROLLER_IDLE
}

var canMove = true
var canMoveVert = true
var state = MovementState.IDLE
var velocity := Vector2()

const MOVE_SPEED := 1000

signal player_collided

func _ready() -> void:
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
	if canMove:
		if Input.is_action_pressed("worldRight"):
			state = MovementState.RIGHT
		if Input.is_action_pressed("worldLeft"):
			state = MovementState.LEFT
		if Input.is_action_pressed("worldUp"):
			if canMoveVert:	
				state = MovementState.UP
			else:
				state = MovementState.SIDESCROLLER_IDLE
		if Input.is_action_pressed("worldDown"):
			if canMoveVert:	
				state = MovementState.DOWN
			else:
				state = MovementState.SIDESCROLLER_IDLE

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
		MovementState.SIDESCROLLER_IDLE:
			$AnimatedSprite.play("IdleDown")
			$AnimatedSprite.scale = Vector2.ONE

func _process(_delta: float) -> void:
	UpdateDirection()
	UpdateAnimation()
	if state == MovementState.IDLE:
		$Footsteps.stop()
	elif $Footsteps.playing == false and canMove:
		$Footsteps.play()

func _physics_process(_delta: float) -> void:
	if canMove:
		velocity = move_and_slide(GetVelocity())

func _on_Overworld_loaded_room(room):
	canMoveVert = room.playerCanMoveVert

func _on_Area2D_area_entered(area):
	emit_signal("player_collided", area)	
	if area is TransitionZone:
		if area.changeFootsteps:
			$Footsteps.stream = area.changeFootstepsTo


func _on_DialogManager_dialog_entered():
	canMove = false
	pass # Replace with function body.


func _on_DialogManager_dialog_end(_initiator):
	canMove = true
	pass # Replace with function body.
