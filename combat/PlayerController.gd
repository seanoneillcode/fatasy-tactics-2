extends Node



export(NodePath) var tilemap
export(NodePath) var movemap
export(NodePath) var player_action_list

var rng
var persons = []
var current_person
var current_action
var last_input_direction

var Pointer
var StartPointer
var TargetPointer
var ActionNode

func _ready():
	tilemap = get_node(tilemap)
	movemap = get_node(movemap)
	player_action_list = get_node(player_action_list)
	Pointer = $Pointer
	StartPointer = $StartPointer
	TargetPointer = $TargetPointer
	ActionNode = $ActionNode
	rng = RandomNumberGenerator.new()
	rng.randomize()
	last_input_direction = "horizontal"


func start_turn(person):
	person.start_pos = Vector2(person.position.x, person.position.y)
	current_person = person
	change_to_moving_state()


func continue_turn(person):
	StartPointer.position.x = person.start_pos.x
	StartPointer.position.y = person.start_pos.y
	current_person = person
	movemap.clear_moves()
	movemap.generate_moves(current_person.start_pos, person.moves)


func _process(delta):
	if Input.is_action_pressed("ui_exit"):
		get_tree().quit()
	if not current_person:
		return
	
	match current_person.state:
		"moving":
			# handle moving
			var direction = get_input_direction()
			if direction.x != 0 or direction.y != 0:
				var target_position = movemap.request_move(current_person.position, direction)
				if target_position:
					var blocking_entity  = tilemap.get_entity_at_pos(current_person.position + (direction * 16))
					if not blocking_entity:
						current_person.move(target_position, direction)
			Pointer.set_position(current_person.position)
			
			# show action list
			if Input.is_action_just_released("ui_accept"):
				change_to_picking_action_state()
			
			# if next player
			if Input.is_action_just_released("ui_next"):
				current_person.next_combatant()
			
		"picking_action":
			if Input.is_action_just_released("ui_accept"):
				var action = player_action_list.get_current_action()
				player_action_list.hide()
				if action == "done":
					movemap.clear_moves()
					current_person.flee()
				else:
					current_action = action
					change_to_picking_target_state(action)
			if Input.is_action_just_released("ui_cancel"):
				change_to_moving_state()
		
		"picking_target":
			if Input.is_action_just_released("ui_cancel"):
				change_to_picking_action_state()
			if Input.is_action_just_released("ui_accept"):
				var target = get_valid_target()
				if target:
					print("target is valid!")
					perform_action(target)
					
			var direction = get_input_direction()
			if direction.x != 0 or direction.y != 0:
				TargetPointer.move(direction)
			# select target square
		
	# once all moves done -> change turn
	# end_turn


func perform_action(target):
	var data = ActionNode.get_action_data(current_action)
	if not data:
		print("error")
		return
	# check if hit
	if rng.randi_range(0,6) == 0: # 1 in  6
		print("miss")
		end_turn()
		return
	var dmg = 10 + rng.randi_range(0,2)
	target.apply_damage(dmg)
	print(target.name, " took damge: ", dmg)
	end_turn()


func end_turn():
	current_action = ""
	movemap.clear_moves()
	TargetPointer.hide()
	Pointer.show()
	StartPointer.show()
	current_person.end_turn()


func change_to_moving_state():
	if current_person.state == "picking_action":
		player_action_list.hide()
	current_person.state = "moving"
	TargetPointer.hide()
	Pointer.show()
	StartPointer.show()


func change_to_picking_target_state(action):
	var min_range = 0
	var max_range = 0
	var data = ActionNode.get_action_data(action)
	if data:
		min_range = data["min_range"]
		max_range = data["max_range"]
	current_person.state = "picking_target"
	movemap.generate_targets(current_person, current_person.position, min_range, max_range)
	TargetPointer.show()
	TargetPointer.position = current_person.position
	Pointer.hide()
	StartPointer.hide()


func change_to_picking_action_state():
	current_action = ""
	movemap.clear_moves()
	movemap.generate_moves(current_person.start_pos, current_person.moves)
	current_person.state = "picking_action"
	player_action_list.get_parent().remove_child(player_action_list)
	current_person.add_child(player_action_list)
	player_action_list.show()
	player_action_list.set_items(current_person.abilities)
	TargetPointer.hide()
	Pointer.show()
	StartPointer.show()


func get_input_direction():
	var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if horizontal != 0 && vertical != 0:
		if last_input_direction == "horizontal":
			horizontal = 0
		elif last_input_direction == "vertical":
			vertical = 0
	else:
		if horizontal != 0:
			last_input_direction = "horizontal"
		if vertical != 0:
			last_input_direction = "vertical"
#	last_input_direction = Vector2(horizontal, vertical)
	return Vector2(horizontal, vertical)
	

func get_valid_target():
	var entity = tilemap.get_entity_at_pos(TargetPointer.position)
	if entity:
		if movemap.is_valid_target(entity.position):
			if entity.team != current_person.team:
				return entity
	
