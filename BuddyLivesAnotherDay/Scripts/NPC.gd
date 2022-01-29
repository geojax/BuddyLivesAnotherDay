extends StaticBody2D

export var timeline := "test-timeline"
#export var sprite_frames: SpriteFrames

var player
var encounters
var cooldown = 0.25
var timer

signal dialog_entered(timeline)

func _ready():
	var _e
	var manager = get_node("/root/Main/ViewportContainer2/Overworld/DialogManager")
	_e = connect("dialog_entered", manager, "_on_NPC_dialog_entered")
	_e = manager.connect("dialog_end", self, "dialog_end")
	add_to_group("NPCs")
	
func _process(_delta):
	if !$NearPrompt.in_dialog && Input.is_action_just_pressed("ui_accept") && $NearPrompt.entered:
		$NearPrompt.body_exit("Player")
		$NearPrompt.in_dialog = true
		$NearPrompt.entered = false
		emit_signal("dialog_entered", timeline, self)

func dialog_end(initiator):
	if initiator == self:
		create_timer(cooldown, "_on_Timer_timeout")
		$NearPrompt.get_node("PromptAnim").play("Enter")

func _on_Timer_timeout():
	if player == null:
		player = find_parent("Overworld").find_node("Player")
	if player != null:
		player.canMove = true
	$NearPrompt.in_dialog = false
	$NearPrompt.entered = true
	
func create_timer(time, function):
	if timer != null:
		delete_timer()
	timer = Timer.new()
	
	timer.set_wait_time(time)
	timer.one_shot = true
	timer.connect("timeout", self, function)
	timer.connect("timeout", self, "delete_timer")
	add_child(timer) #to process
	timer.start() #to start

func delete_timer():
	if timer != null && is_instance_valid(timer):
		timer.queue_free()

# called by Room.gd and RoomParent.gd
#disables NPC if not in the room
func enableIfInRoom(roomName: String):
	if !NPCs.isNPCInRoom(name, roomName):
		queue_free()
