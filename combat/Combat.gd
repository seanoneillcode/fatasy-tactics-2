extends Node

signal combat_finished(winner, loser)

func _ready():
#	initialize($TempNode.combat_actor)
	$Camera2D.set_follow_node(null)


func initialize(combat_combatants):
	for combatant in combat_combatants:
		var combatant_instance = combatant.instance()
		if combatant_instance is Combatant:
			$TileMap.add_combatant(combatant_instance)
			combatant_instance.connect("death", self, "_on_combatant_death")
		else:
			combatant_instance.queue_free()
	$TurnQueue.initialize()


func clear_combat():
	for n in $TileMap.get_children():
		n.queue_free()


func finish_combat(winner):
	print("combat finished, winner: ", winner)
	emit_signal("combat_finished", winner)


func _on_combatant_death():
	var teamA = 0
	var teamB = 0
	for n in $TileMap.get_children():
		if n.team == "a" && !n.is_dead():
			teamA += 1
		if n.team == "b" && !n.is_dead():
			teamB += 1
	if teamA == 0:
		print("team b wins")
		# handle this
		yield(get_tree().create_timer(2.0), "timeout")
		finish_combat("b")
	if teamB == 0:
		print("team a wins")
		yield(get_tree().create_timer(2.0), "timeout")
		finish_combat("a")
	
	
