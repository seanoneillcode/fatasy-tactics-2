extends Node

export(NodePath) var combatants_list
export(NodePath) var player_controller

var queue = [] setget set_queue
var teamA = []
var teamB = []
var currentTeam = "a"

func _ready():
	combatants_list = get_node(combatants_list)
	player_controller = get_node(player_controller)


func initialize():
	for combatant in combatants_list.get_children():
		if combatant.team == "a":
			teamA.append(combatant)
		else:
			teamB.append(combatant)
	set_queue(teamA)
	next_turn()


func next_turn():
	var person = get_next_in_queue()
	if currentTeam == "a":
		player_controller.continue_turn(person)
	else:
		person.take_turn()


func get_next_in_queue():
	var current_combatant = queue.pop_front()
	current_combatant.disconnect("turn_finished", self, "next_turn")
	if !current_combatant.isDone:
		queue.append(current_combatant)
		
	if queue.size() == 0:
		switch_teams()
	
	var active_combatant = queue[0]
	active_combatant.connect("turn_finished", self, "next_turn")
	return active_combatant


func switch_teams():
	if currentTeam == "a":
		currentTeam = "b"
		set_queue(teamB)
	else:
		currentTeam = "a"
		set_queue(teamA)


func remove(combatant):
	var new_queue = []
	for n in queue:
		new_queue.append(n)
	new_queue.remove(new_queue.find(combatant))
	combatant.queue_free()
	self.queue = new_queue


func set_queue(new_queue):
	queue.clear()
	for node in new_queue:
		if not node is Combatant:
			continue
		queue.append(node)
	for item in queue:
		item.isDone = false
		player_controller.start_turn(item)
			

