extends Node

onready var overworld = get_node("/root").find_node("Overworld")

var polecat := NPCData.new("polecat", ["Main-Four"])
var otter := NPCData.new("otter", ["Docks-Three"])
var badger := NPCData.new("badger",["Sub-One"])
var owl := NPCData.new("owl",["Main-Two"])
var lilstar := NPCData.new("lilstar",[])
var dippers := NPCData.new("dippers",["Docks-Three","Sub-Two"])
var bigstar := NPCData.new("bigstar",[]) # Not on map at first
var leo := NPCData.new("leo",["West-Two"])
var ferret := NPCData.new("ferret",["West-Two"])

var rooms := {
	"Docks-One": [],
	"Docks-Two": [],
	"Docks-Three":[dippers, otter],
	"West-One": [bigstar],
	"West-Two": [ferret, leo],
	"Main-One": [],
	"Main-Two": [owl],
	"Main-Four": [],
	"North-One": [],
	"North-Two": [],
	"North-Four": [owl],
	"Sub-One": [badger],
	"Sub-Two": []
}

func isNPCInRoom(npcName: String, roomName: String) -> bool:
	for room in rooms:
		for npcdata in rooms[room]:
			if npcdata.name == npcName:
				return true
	return false
