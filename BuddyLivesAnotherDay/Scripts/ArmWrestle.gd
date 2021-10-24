extends Node2D

enum FightState {
	NORMAL,
	EXPOSED,
	STUNNED
}
var state = FightState.NORMAL

const STUN_TIME = 1
const MIN_EXPOSE_DELAY_TIME = 5
const MAX_EXPOSE_DELAY_TIME = 15

# how fast progress/stamina increase or decrease.
var fightProgressDecay = .4
var pushEffectiveness = .4
var pushStaminaCost = .4
var staminaRegen = 2

var fightProgress = 50
var stamina := 100

onready var exposeDelayTimer := get_node("ExposeDelayTimer")
onready var exposeTimer := get_node("ExposeTimer")
onready var stunTimer := get_node("StunTimer")
onready var fightProgressBar := get_node("FightProgressBar")
onready var staminaProgressBar := get_node("StaminaProgressBar")
	
func UpdateProgressBars() -> void:
	fightProgress = clamp(fightProgress, 0, 100)
	fightProgressBar.value = fightProgress
	
	stamina = clamp(stamina, 0, 100)
	staminaProgressBar.value = stamina
	
func UpdateFightNormal() -> void:
	fightProgress -= fightProgressDecay
	if Input.is_action_pressed("armWrestlePush"):
		fightProgress += pushEffectiveness
		stamina -= pushStaminaCost
	else:
		stamina += staminaRegen
	
func UpdateFightExposed() -> void:
	if Input.is_action_just_pressed("armWrestleStun"):
		exposeTimer.stop()
		state = FightState.STUNNED
		print("Stunned!")
		stunTimer.start(STUN_TIME)
		
func UpdateFightStunned() -> void:
	if Input.is_action_just_pressed("armWrestlePush"):
		fightProgress += 3
	
func _ready():
	fightProgressBar.value = 50
	exposeDelayTimer.start(floor(rand_range(MIN_EXPOSE_DELAY_TIME, MAX_EXPOSE_DELAY_TIME)))

func _process(delta):
	match state:
		FightState.NORMAL:
			UpdateFightNormal()
		FightState.EXPOSED:
			UpdateFightExposed()
		FightState.STUNNED:
			UpdateFightStunned()
	UpdateProgressBars()
		
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
