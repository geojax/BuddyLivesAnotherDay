class_name NPC
extends StaticBody2D

export var timeline := "test-timeline"

var player
var encounters = 0
export var npcName := String()
var cooldown = 0.25
var timer
signal dialog_entered(timeline)

var rooms:= Array()

# the following arrays just store initialization data.
# set them in the editor.
export var roomNames:=PoolStringArray()
export var roomPos := PoolVector2Array()

func _ready():
	print_debug(name, " loaded")	
	var _e
	var manager = get_node("../DialogManager")
	_e = connect("dialog_entered", manager, "_on_NPC_dialog_entered")
	_e = manager.connect("dialog_end", self, "dialog_end")
	add_to_group("NPCs")
	get_node("..").connect("load_room", self, "_on_Overworld_load_room")
	
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
	for i in range(roomNames.size()):
		rooms.append(RoomData.new(roomNames[i], roomPos[i], true))
	
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

func _on_Overworld_load_room(roomName:String, var _something):
	print(roomName)
	enableIfInRoom(roomName)
	encounters+=1
	pass

# called by Room.gd and RoomParent.gd
#disables NPC if not in the room
# enables if in the room
func enableIfInRoom(roomName: String):
	var isOn = false
	print(name, " checking ", roomName)
	print(rooms)
	for room in rooms:
		print(name, " ", roomName, " ", room.present, " ", room.roomName)
		if room.roomName == roomName and room.present:
			print("setting isOn to true....")			
			position = room.pos
			isOn = true
		break
#	print(name, " ", roomName, " ", isOn)
	$CharacterCollision.disabled = !isOn
	$NearPrompt.visible = isOn
	visible = isOn

func setStatusInRoom(roomName:String, present:bool):
	for room in rooms:
		if room.roomName == roomName:
			room.present = present
