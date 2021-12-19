extends Node


var current_person
export(NodePath) var tilemap
export(NodePath) var movemap
export(NodePath) var player_action_list

var persons = []

func _ready():
	tilemap = get_node(tilemap)
	movemap = get_node(movemap)
	player_action_list = get_node(player_action_list)

func start_turn(person):
	person.state = "moving"
	current_person = person
	movemap.generate_moves(person)

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
					current_person.move(target_position, direction)
			
			# show action list
			if Input.is_action_just_released("ui_accept"):
				current_person.state = "picking_action"
				player_action_list.get_parent().remove_child(player_action_list)
				current_person.add_child(player_action_list)
				player_action_list.show()
				player_action_list.set_items(current_person.abilities)
			
		"picking_action":
			if Input.is_action_just_released("ui_accept"):
				var action = player_action_list.get_current_action()
				print("selected action: ", action)
				player_action_list.hide()
				handleChosenAction(action, current_person)
				
		
		"picking_target":
			var direction = get_input_direction()
			if direction.x == 0 and direction.y == 0:
				return
			# select target square
		
	# once all moves done -> change turn
	# end_turn

func handleChosenAction(action, person):
	match action:
		"skip":
			movemap.clear_moves()
			person.flee()
			print("end player turn")
		"cancel":
			person.state = "moving"
			print("cancel action selection")

func get_input_direction():
	var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return Vector2(horizontal, vertical)
	
