extends Node

# Every room has an array of NPCs
# Every NPC records how many encounters it has in here
# 
var NPC:PackedScene = preload("res://Scenes/NPCs/NPC.tscn")

var polecat := NPC.instance()
var otter := makeNPC(Vector2(1000,250), "res://Art/honeybadger1.png")
var badger := NPC.instance()
var owl := NPC.instance()
var lilstar := NPC.instance()
var dippers := NPC.instance()
var bigstar := NPC.instance()
var leo := NPC.instance()
var ferret := load("res://Scenes/NPCs/Ferret.tscn")

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

func makeNPC(pos:Vector2, spritepath: String) -> PackedScene:
	var ret = NPC.instance()
	ret.position = pos
	ret.get_node("Sprite").texture = load(spritepath)
	ret.get_node("Sprite").scale = Vector2(0.2,0.2)
	return ret

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Append this NPC to the corresponding room.
# NPCs have a number of encounters.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
