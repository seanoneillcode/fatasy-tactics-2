extends Node2D

#warning-ignore:unused_class_variable
export(Array, PackedScene) var combat_actor
#warning-ignore:unused_class_variable
var lost = false
	
var type = "opponent"

signal opponent_start_combat

func _ready():
	if has_node("DialoguePlayer"):
		var dialoguePlayer = get_node("DialoguePlayer")
		dialoguePlayer.connect("dialogue_finished", self, "_on_dialogue_finished")

func _on_dialogue_finished():
	print("opponent dialogue finished")
	emit_signal("opponent_start_combat", self)
