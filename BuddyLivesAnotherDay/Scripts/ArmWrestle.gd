extends Node2D
# TODO: These timers are an issue.
# Since the timers affect state, changing state
# Must reset the timers somehow,
# Or we can change the effects of the timers on state

enum FightState {
	NORMAL,
	EXPOSED,
	BOSS_STUNNED,
	PLAYER_STUNNED,
	WIN,
	LOSE,
	IDLE
}
var state = FightState.NORMAL setget changeState

const STUN_TIME = 2
const MIN_EXPOSE_DELAY_TIME = 5
const MAX_EXPOSE_DELAY_TIME = 15

# how fast progress/stamina increase or decrease.
const BOSSPUSH = .1
const BOSSHEAVYPUSH = .4
const PLAYERPUSH = .2
var pushStaminaCost = .3
var staminaRegen = .4

var fightProgress = 50.0
var stamina = 100.0

var timeElapsed = 0

var fakeoutChance = 20
onready var exposeDelayTimer := get_node("ExposeDelayTimer")
onready var exposeTimer := get_node("ExposeTimer")
onready var stunTimer := get_node("StunTimer")
onready var fightProgressBar := get_node("ColorRect/FightProgressBar")
onready var staminaProgressBar := get_node("ColorRect/StaminaProgressBar")
	
signal victory
signal defeat
	
func EnterScreen():
	$AnimationPlayer.play("EnterScreen")
	
func ExitScreen():
	$AnimationPlayer.play_backwards("EnterScreen")	
	state = FightState.IDLE

func changeState(newState):
	state = newState
	print(state)

func _ready():
	#EnterScreen()
	randomize()
		
	fightProgressBar.value = 50
	exposeDelayTimer.start(floor(rand_range(MIN_EXPOSE_DELAY_TIME, MAX_EXPOSE_DELAY_TIME)))

func _process(delta):
	match state:
		FightState.NORMAL:
			fightProgress -= BOSSPUSH
			if Input.is_action_pressed("armWrestlePush") and stamina > 0:
				fightProgress += float(PLAYERPUSH)
				stamina -= pushStaminaCost 
			elif Input.is_action_just_pressed("armWrestleStun"):
				state = FightState.PLAYER_STUNNED
				exposeDelayTimer.stop()
				exposeTimer.stop()
				stunTimer.start()
#				exposeDelayTimer.emit_signal("timeout")
			else:
				stamina += staminaRegen
				
		# during this state, boss is exposed and attacking.	
		# definitely not a fakeout.	
		FightState.EXPOSED:
			fightProgress -= BOSSPUSH
			if Input.is_action_just_pressed("armWrestleStun"):
				exposeTimer.stop()
				stunTimer.start(STUN_TIME)
				state = FightState.BOSS_STUNNED
				print ("Enemy BOSS_STUNNED!")
				
		FightState.BOSS_STUNNED:
			# if it wasn't a fakeout, then the player pressed right correctly
			if Input.is_action_just_pressed("armWrestlePush"):
				fightProgress += 3
			else:
				stamina += staminaRegen
				
		FightState.PLAYER_STUNNED:
			fightProgress -= BOSSHEAVYPUSH
		
		FightState.WIN:
			emit_signal("victory")
			exposeDelayTimer.stop()
			exposeTimer.stop()
			stunTimer.stop()
			
		FightState.LOSE:
			emit_signal("defeat")
			exposeDelayTimer.stop()
			exposeTimer.stop()
			stunTimer.stop()
			
	fightProgress = clamp(fightProgress, 0, 100)
	stamina = clamp(stamina, 0, 100)	
	
	if fightProgress == 0:
		state = FightState.LOSE
	elif fightProgress == 100:
		state = FightState.WIN
	fightProgressBar.value = fightProgress
	staminaProgressBar.value = stamina
	
	$hands.position.x = 7 * fightProgress + 200
	
# Set state to EXPOSED.
# The enemy's special attack begins.
# The player has a chance to counter during this window.
func _on_ExposeDelayTimer_timeout():
	var f = randi() % 100
	if f < fakeoutChance:
		print("FAKE!")
		state = FightState.NORMAL
		return
	else:
		print("REAL! PRESS RIGHT!")
	state = FightState.EXPOSED
	exposeTimer.start(3)

# Set state to NORMAL.
# Enemy's special attack ends.
# Reset the timer until his next attack.
func _on_ExposeTimer_timeout():
	print("Expose timer end!")
	
	state = FightState.NORMAL
	exposeDelayTimer.start(randi() % 10 + 10)

func _on_StunTimer_timeout():
	state = FightState.NORMAL
	exposeDelayTimer.start()
