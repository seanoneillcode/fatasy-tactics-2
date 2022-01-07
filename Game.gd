extends Node

export(NodePath) var combat_screen
export(NodePath) var exploration_screen


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
	$Exploration/Camera2D.set_follow_node($Exploration/Grid/Player)


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
	yield($AnimationPlayer, "animation_finished")
	
	exploration_screen.handle_combat_result(winner)
	
#	combat_screen_instance.clear_combat()

	
