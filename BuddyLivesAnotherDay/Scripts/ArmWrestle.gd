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
var fightProgressDecay = .2
var pushEffectiveness = .6
var pushStaminaCost = .3
var staminaRegen = .4

var enemyStrength = 1.0;

var fightProgress = 50.0
var stamina = 100.0

var timeElapsed = 0;

onready var exposeDelayTimer := get_node("ExposeDelayTimer")
onready var exposeTimer := get_node("ExposeTimer")
onready var stunTimer := get_node("StunTimer")
onready var fightProgressBar := get_node("FightProgressBar")
onready var staminaProgressBar := get_node("StaminaProgressBar")
	
func UpdateProgressBars() -> void:
	fightProgressBar.value = fightProgress
	staminaProgressBar.value = stamina
	$EnemyStrengthBar.value = abs(sin(timeElapsed))*100.0;
	
func UpdateFightNormal() -> void:
	fightProgress -= fightProgressDecay
	if Input.is_action_pressed("armWrestlePush"):
		fightProgress += pushEffectiveness
		stamina -= pushStaminaCost * enemyStrength * 2;
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
	else:
		stamina += staminaRegen
	
func _ready():
	fightProgressBar.value = 50
	exposeDelayTimer.start(floor(rand_range(MIN_EXPOSE_DELAY_TIME, MAX_EXPOSE_DELAY_TIME)))

func _process(delta):
	enemyStrength = abs(sin(timeElapsed));
	timeElapsed += delta;
	match state:
		FightState.NORMAL:
			UpdateFightNormal()
		FightState.EXPOSED:
			UpdateFightExposed()
		FightState.STUNNED:
			UpdateFightStunned()
			
	fightProgress = clamp(fightProgress, 0, 100)
	stamina = clamp(stamina, 0, 100)	
	UpdateProgressBars()
		
func _on_ExposeDelayTimer_timeout():
	print("PRESS RIGHT!")
	state = FightState.EXPOSED
	exposeTimer.start(1)

func _on_ExposeTimer_timeout():
	print("Expose timer end!")
	state = FightState.NORMAL
	exposeDelayTimer.start(randi() % 10 + 10)

func _on_StunTimer_timeout():
	state = FightState.NORMAL
