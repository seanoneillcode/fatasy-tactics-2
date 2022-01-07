extends Node2D

const PLAYER_WIN = "res://dialogue/dialogue_data/player_won.json"
const PLAYER_LOSE = "res://dialogue/dialogue_data/player_lose.json"

func _ready():
	$Camera2D.set_follow_node($Grid/Player)


func handle_combat_result(winner):
	var dialogue = load("res://dialogue/dialogue_player/DialoguePlayer.tscn").instance()
	if winner == "a":
		dialogue.dialogue_file = PLAYER_WIN
	else:
		dialogue.dialogue_file = PLAYER_LOSE
		
	$Camera2D/Dialogue/DialogueUI.show_dialogue($Grid/Player, dialogue)
	yield(dialogue, "dialogue_finished")
	dialogue.queue_free()
