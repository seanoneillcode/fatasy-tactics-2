extends TileMap


export(NodePath) var tilemap

# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = get_node(tilemap)
	clear()

var moves = []

func clear_moves():
	moves.clear()
	clear()

func generate_moves(entity):
	clear_moves()
	add_moves(tilemap.world_to_map(entity.position), entity.moves)
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
#
