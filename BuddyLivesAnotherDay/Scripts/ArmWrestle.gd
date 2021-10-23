extends Node2D

enum FightState {
	NORMAL,
	EXPOSED,
	STUNNED
}
var state = FightState.NORMAL

const STUNTIME = 1
const MIN_EXPOSE_DELAY_TIME = 5
const MAX_EXPOSE_DELAY_TIME = 15

onready var exposeDelayTimer = get_node("ExposeDelayTimer")
onready var exposeTimer = get_node("ExposeTimer")
onready var stunTimer = get_node("StunTimer")
onready var fightProgressBar = get_node("FightProgressBar")

func UpdateFight() -> void:
	match state:
		FightState.NORMAL:
			fightProgressBar.value -= .5
			if Input.is_action_just_pressed("armWrestlePush"):
				fightProgressBar.value += 5
			pass
			
		FightState.EXPOSED:
			if Input.is_action_just_pressed("armWrestleStun"):
				exposeTimer.stop()
				state = FightState.STUNNED
				print("Stunned!")
				stunTimer.start(1)
			pass
			
		FightState.STUNNED:
			if Input.is_action_just_pressed("armWrestlePush"):
				fightProgressBar.value += 3

func _ready():
	fightProgressBar.value = 50
	exposeDelayTimer.start(floor(rand_range(MIN_EXPOSE_DELAY_TIME, MAX_EXPOSE_DELAY_TIME)))

func _process(delta):
	UpdateFight()


func _on_ExposeDelayTimer_timeout():
	print("PRESS RIGHT!")
	state = FightState.EXPOSED
	exposeTimer.start(1)
	pass # Replace with function body.


func _on_ExposeTimer_timeout():
	print("Expose timer end!")
	state = FightState.NORMAL
	exposeDelayTimer.start(randi() % 10 + 10)
	pass # Replace with function body.


func _on_StunTimer_timeout():
	state = FightState.NORMAL
	pass # Replace with function body.
