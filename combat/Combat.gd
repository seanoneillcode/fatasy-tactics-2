extends Node

signal combat_finished(winner, loser)

func _ready():
	initialize($TempNode.combat_actor)

func initialize(combat_combatants):
	for combatant in combat_combatants:
		var combatant_instance = combatant.instance()
		if combatant_instance is Combatant:
			$TileMap.add_combatant(combatant_instance)
			combatant_instance.get_node("Health").connect("dead", self, "_on_combatant_death", [combatant_instance])
		else:
			combatant_instance.queue_free()
#	$UI.initialize()
	$TurnQueue.initialize()


func clear_combat():
	for n in $TileMap.get_children():
		n.queue_free()
#	for n in $UI/Combatants.get_children():
#		n.queue_free()


func finish_combat(winner, loser):
	emit_signal("combat_finished", winner, loser)


func _on_combatant_death(combatant):
	var winner
	if not combatant.name == "Player":
		winner = $TileMap/Player
	else:
		for n in $TileMap.get_children():
			if not n.name == "Player":
				winner = n
				break
	finish_combat(winner, combatant)
