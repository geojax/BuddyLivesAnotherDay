extends Node

onready var overworld = get_node("/root").find_node("Overworld")

#var polecat := NPCData.new(["Main-Four"])
#var otter := NPCData.new(["Docks-Three"])
#var badger := NPCData.new(["Sub-One"])
#var owl := NPCData.new(["Main-Two"])
#var lilstar := NPCData.new([])
#var dippers := NPCData.new(["Docks-Three","Sub-Two"])
#var bigstar := NPCData.new([]) # Not on map at first
#var leo := NPCData.new(["West-Two"])
#var ferret := NPCData.new(["West-Two"])

var rooms := {
	"Docks-One": [],
	"Docks-Two": [],
	"Docks-Three":["dippers", "otter"],
	"West-One": ["bigstar"],
	"West-Two": ["ferret", "leo"],
	"Main-One": [],
	"Main-Two": ["owl"],
	"Main-Four": [],
	"North-One": [],
	"North-Two": [],
	"North-Four": ["owl"],
	"Sub-One": ["badger"],
	"Sub-Two": []
}

func isNPCInRoom(npcName: String, roomName: String) -> bool:
	return rooms[roomName].has(npcName)
