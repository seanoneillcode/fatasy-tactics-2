extends Node2D

var type = "object"

var lost = false
export(String, FILE, "*.json") var dialogue_file

func _ready():
	if dialogue_file:
		$DialoguePlayer.dialogue_file = dialogue_file
