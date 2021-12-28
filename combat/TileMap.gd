extends TileMap

var teamACount = 0
var teamBCount = 0

func add_combatant(new_combatant):
	print(new_combatant.team)
	if new_combatant.team == "a":
		# player
		new_combatant.position.x = (16 * 8)
		new_combatant.position.y = 64 + (16 * teamACount)
		new_combatant.z_index = 3
		add_child(new_combatant)
		teamACount += 1
	else:
		new_combatant.position.x = (16 * 10)
		new_combatant.position.y = 64 + (16 * teamBCount)
		teamBCount += 1
		
	add_child(new_combatant)
	new_combatant.z_index = 10

func request_move(position, direction):
	var cell_start = world_to_map(position)
	var cell_target = cell_start + direction

	var cell_tile_id = get_cellv(cell_target)
	
	var target_entity = get_cell_entity(cell_target)
	if target_entity:
		return
	
	var tileData = tile_set.getTileData(cell_tile_id)
	if tileData["is_blocking"]:
		return
	return map_to_world(cell_target)


func request_tile_move(cell_target):
	var cell_tile_id = get_cellv(cell_target)
	var tileData = tile_set.getTileData(cell_tile_id)
	if tileData["is_blocking"]:
		return
	return cell_target


func can_target_tile(entity, tile_pos):
	var cell_tile_id = get_cellv(tile_pos)
	var tileData = tile_set.getTileData(cell_tile_id)
	if tileData["is_blocking"]:
		return false
	var target_entity = get_cell_entity(tile_pos)
	if target_entity && target_entity != entity:
		return false
	return true


func get_entity_at_pos(position):
	return get_cell_entity(world_to_map(position))

func get_cell_entity(cell):
	for entity in get_children():
		if world_to_map(entity.position) == cell:
			return(entity)
