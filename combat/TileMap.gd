extends TileMap

var teamACount = 0
var teamBCount = 0

func add_combatant(new_combatant):
	print(new_combatant.team)
	if new_combatant.team == "a":
		# player
		new_combatant.position.x = 32
		new_combatant.position.y = 64 + (16 * teamACount)
		add_child(new_combatant)
		teamACount += 1
	else:
		new_combatant.position.x = 272
		new_combatant.position.y = 64 + (16 * teamBCount)
		teamBCount += 1
		
	add_child(new_combatant)
