class_name NPC
extends StaticBody2D

export var timeline := "test-timeline"

var player
var encounters = 0
export var npcName := String()
var cooldown = 0.25
var timer
signal dialog_entered(timeline) # called with two extra optional timelines

var rooms = {}

# the following arrays just store initialization data.
# set them in the editor.
export var roomNames:=PoolStringArray()
export var roomPos := PoolVector2Array()

func _ready():
	print_debug(name, " loaded")	
	add_to_group("NPCs")	
	var _e
	var manager = get_tree().root.get_node("Main/ViewportContainer2/Overworld/DialogManager")
#	_e = connect("dialog_entered", manager, "_on_NPC_dialog_entered")
	_e = manager.connect("dialog_end", self, "dialog_end")
	get_node("..").connect("loaded_room", self, "_on_Overworld_load_room")
	
	# get Data from this NPC's data file.
	var npcDataFile = File.new()
	if npcDataFile.open("res://NPCData/" + name + ".json", File.READ) != OK:
		print("Could not open ",name,".json")
		return
	var npcDataText = npcDataFile.get_as_text()
	print(npcDataText)
	npcDataFile.close()
	var parsedData = JSON.parse(npcDataText)
	if parsedData.error != OK:
		print("trouble parsing data for ", name)
		return
	for r in parsedData.result["rooms"]:
		roomNames.append(r["name"])
		roomPos.append(Vector2(r["posx"],r["posy"]))
		pass
	# initialize all rooms this NPC is in
	var i = 0
	for room in roomNames:
		rooms[room]=RoomData.new(roomPos[i], true)
		i+=1
	
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

func _on_Overworld_load_room(room):
	enableIfInRoom(room.name)
	encounters+=1
	print_debug(name, " encountered")
	pass

# called in the above functionon ready
# disables NPC if not in the room
# enables if in the room
func enableIfInRoom(roomName: String):
	var isOn = false
	if  rooms.has(roomName) and rooms[roomName].present:
		position = rooms[roomName].pos
		isOn = true
	$CharacterCollision.disabled = !isOn
	$NearPrompt.visible = isOn
	visible = isOn

func setStatusInRoom(roomName:String, present:bool):
	if rooms[roomName].present:
		rooms[roomName].present = present
		print_debug(name, " no longer in ", roomName)
