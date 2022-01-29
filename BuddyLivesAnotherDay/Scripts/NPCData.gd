class_name NPCData
extends Node

# Encounters increments to determine the behavior of the NPC
# as the player interacts with it. Examples of encounters may
# include entering the same room as the NPC, speaking with 
# the NPC, or fulfilling some condition.
var encounters : int = 0 setget setEncounters, getEncounters
var locations : PoolStringArray setget setLocation, getLocation

func setLocation(newLoc):
	var ret = locations
	locations = newLoc
	return ret
	pass
	
func getLocation():
	return locations
	pass
	
# Return the value of encounters being replaced
func setEncounters(newEnc) -> int:
	var ret:int = encounters
	encounters = newEnc
	return ret
	pass

func getEncounters() -> int:
	return encounters
	pass

func _init(var npcName:String, loc:PoolStringArray):
	name = npcName
	encounters = 0
	locations = loc
	pass
