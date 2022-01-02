extends Node

export(NodePath) var combat_screen
export(NodePath) var exploration_screen

const PLAYER_WIN = "res://dialogue/dialogue_data/player_won.json"
const PLAYER_LOSE = "res://dialogue/dialogue_data/player_lose.json"

var combat_screen_instance

func _ready():
	exploration_screen = get_node(exploration_screen)
	combat_screen_instance = get_node(combat_screen)
	combat_screen_instance.connect("combat_finished", self, "_on_combat_finished")
	for n in $Exploration/Grid.get_children():
		if not n.has_node("DialoguePlayer"):
			continue
		if n.type == "opponent":
			n.connect("opponent_start_combat", self, "_on_opponent_start_combat")
	remove_child(combat_screen_instance)


func start_combat(combat_actors):

	remove_child($Exploration)
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	add_child(combat_screen_instance)
	combat_screen_instance.show()
	combat_screen_instance.initialize(combat_actors)
	$AnimationPlayer.play_backwards("fade")


func _on_opponent_start_combat(opponent):
	if opponent.lost:
		return
	var player = $Exploration/Grid/Player
	var combatants = player.combat_actor + opponent.combat_actor
	start_combat(combatants)


func _on_combat_finished(winner):

	remove_child(combat_screen_instance)
	combat_screen_instance.queue_free()
	$AnimationPlayer.play_backwards("fade")
	add_child(exploration_screen)
	var dialogue = load("res://dialogue/dialogue_player/DialoguePlayer.tscn").instance()
	if winner == "a":
		dialogue.dialogue_file = PLAYER_WIN
	else:
		dialogue.dialogue_file = PLAYER_LOSE
	yield($AnimationPlayer, "animation_finished")
	var player = $Exploration/Grid/Player
	exploration_screen.get_node("Node2D/DialogueUI").show_dialogue(player, dialogue)
#	combat_screen_instance.clear_combat()
	yield(dialogue, "dialogue_finished")
	dialogue.queue_free()
