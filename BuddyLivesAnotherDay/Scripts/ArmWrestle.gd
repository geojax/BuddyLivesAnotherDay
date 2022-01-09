extends Node2D

enum FightState {
	NORMAL,
	SPECIAL_ATTACK,
	BOSS_STUNNED,
	PLAYER_STUNNED,
	WIN,
	LOSE,
	IDLE
}
var state = FightState.NORMAL setget changeState

const STUN_TIME = 2
const MIN_EXPOSE_DELAY_TIME = 5 # Minimum length of NORMAL state.
const MAX_EXPOSE_DELAY_TIME = 15 # Max length of NORMAL state.

# how fast progress/stamina increase or decrease.
const BOSSPUSH = .05
const BOSSHEAVYPUSH = .8
const PLAYERPUSH = .1
var pushStaminaCost = .15
var staminaRegen = .08

var fightProgress = 50.0 
var stamina = 100.0

var timeElapsed = 0

var fakeoutChance = 20

var fightLengthModifier = 1

var specialAttackDelayTimer : Timer
var specialAttackTimer : Timer
var stunTimer : Timer
var loseTimer : Timer

onready var fightProgressBar := get_node("ColorRect/FightProgressBar")
onready var staminaProgressBar := get_node("ColorRect/StaminaProgressBar")
	
signal victory
signal defeat

func start():
	$AnimationPlayer.play("EnterScreen")
	print_debug("Starting the match")
	state = FightState.NORMAL
	specialAttackDelayTimer.start(floor(rand_range(MIN_EXPOSE_DELAY_TIME, MAX_EXPOSE_DELAY_TIME)))	
	
func ExitScreen():
	$AnimationPlayer.play_backwards("EnterScreen")	
	state = FightState.IDLE

func changeState(newState):
	state = newState
	print(state)

func _ready():
#	EnterScreen()
	specialAttackDelayTimer = $ExposeDelayTimer
	specialAttackTimer = $ExposeTimer
	stunTimer = $StunTimer
	loseTimer = $LoseTimer
	state = FightState.IDLE
	fightProgressBar.value = 50

func _process(_delta):
	match state:
		# Boss pushes constantly.
		# Holding left maintains the fight's position.
		# Pressing right stuns the player.
		FightState.NORMAL:
			fightProgress -= BOSSPUSH
			if Input.is_action_pressed("armWrestlePush"):
				if stamina > 0:
					fightProgress += PLAYERPUSH
					stamina -= pushStaminaCost 
			elif Input.is_action_just_pressed("armWrestleStun"):
				state = FightState.PLAYER_STUNNED
				specialAttackDelayTimer.stop()
				specialAttackTimer.stop()
				stunTimer.start()
			else:
				stamina += staminaRegen
				
		# Boss is special-attacking and exposed.
		# If the player presses right, boss is stunned.
		FightState.SPECIAL_ATTACK:
			fightProgress -= BOSSHEAVYPUSH
			if Input.is_action_just_pressed("armWrestleStun"):
				specialAttackTimer.stop()
				stunTimer.start(STUN_TIME)
				state = FightState.BOSS_STUNNED
				print ("Enemy Stunned!")
		
		# Player regains stamina and progress with every left keypress.
		FightState.BOSS_STUNNED:
			if Input.is_action_just_pressed("armWrestlePush"):
				fightProgress += 2
				stamina += staminaRegen * 10
		
		# Player loses progress quickly.		
		FightState.PLAYER_STUNNED:
			fightProgress -= BOSSHEAVYPUSH
			
		FightState.WIN:
			print("Player wins")
			emit_signal("victory")
			specialAttackDelayTimer.stop()
			specialAttackTimer.stop()
			stunTimer.stop()
			loseTimer.stop()
			state = FightState.IDLE
			
		FightState.LOSE:
			print("Player loses")
			emit_signal("defeat")
			specialAttackDelayTimer.stop()
			specialAttackTimer.stop()
			stunTimer.stop()
			loseTimer.stop()
			state = FightState.IDLE
			
	fightProgress = clamp(fightProgress, 0, 100)
	stamina = clamp(stamina, 0, 100)	
	
	if fightProgress == 0 and loseTimer.is_stopped() and state != FightState.IDLE:
		loseTimer.start()
	elif fightProgress > 5:
		loseTimer.stop()
	if fightProgress == 100:
		state = FightState.WIN
	fightProgressBar.value = fightProgress
	staminaProgressBar.value = stamina
	
	$hands.position.x = 7 * fightProgress + 200
	
# Set state to SPECIAL_ATTACK.
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
	state = FightState.SPECIAL_ATTACK
	specialAttackTimer.start(3)

# Set state to NORMAL.
# Enemy's special attack ends.
# Reset the timer until his next attack.
func _on_ExposeTimer_timeout():
	print("Expose timer end!")
	
	state = FightState.NORMAL
	specialAttackDelayTimer.start(randi() % 4 + 5)

func _on_StunTimer_timeout():
	state = FightState.NORMAL
	specialAttackDelayTimer.start(randi() % 4 + 5)


func _on_LoseTimer_timeout():
	state = FightState.LOSE
	pass # Replace with function body.
