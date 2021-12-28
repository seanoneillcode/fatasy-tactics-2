extends TileMap


export(NodePath) var tilemap

var moves = []


func _ready():
	tilemap = get_node(tilemap)
	clear()


func clear_moves():
	moves.clear()
	clear()


func generate_moves(pos, mov):
	clear_moves()
	add_moves(tilemap.world_to_map(pos), mov)
	for move in moves:
		set_cellv(move, 0)
	update_bitmask_region(Vector2(),Vector2(320, 180))


func request_move(position, direction):
	var cell_start = world_to_map(position)
	var cell_target = cell_start + direction
	var value = get_cellv(cell_target)
	if value == 0:
		return map_to_world(cell_target)
	return


func add_moves(tile_position, moves_left):
	if moves_left < -3:
		return
	var newTilePos = tilemap.request_tile_move(tile_position)
	if newTilePos:
		if !moves.has(newTilePos):
			moves.append(newTilePos)
		add_moves(newTilePos + Vector2(-1,0), moves_left - 1)
		add_moves(newTilePos + Vector2(1,0), moves_left - 1)
		add_moves(newTilePos + Vector2(0,1), moves_left - 1)
		add_moves(newTilePos + Vector2(0,-1), moves_left - 1)


func generate_targets(entity, start_pos, min_range, max_range):
	clear_moves()
	var targets = []
	_get_targets(entity, world_to_map(start_pos), min_range, max_range, Vector2(1,0), targets)
	_get_targets(entity, world_to_map(start_pos), min_range, max_range, Vector2(0,1), targets)
	_get_targets(entity, world_to_map(start_pos), min_range, max_range, Vector2(-1,0), targets)
	_get_targets(entity, world_to_map(start_pos), min_range, max_range, Vector2(0,-1), targets)
	for target in targets:
		set_cellv(target, 0)
	update_bitmask_region(Vector2(),Vector2(320, 180))


func _get_targets(entity, start_tile_pos, min_range, max_range, direction, targets):
	var pos = Vector2(start_tile_pos.x, start_tile_pos.y)
	for index in range(max_range + 1):
		var can_target = tilemap.can_target_tile(entity, pos)
		if can_target:
			if index >= min_range:
				if !targets.has(pos):
					targets.append(pos)
			pos = pos + direction
		else:
			if index >= min_range:
				if !targets.has(pos):
					targets.append(pos)
			break


func is_valid_target(position):
	var value = get_cellv(world_to_map(position))
	if value == 0:
		return true
	return false
