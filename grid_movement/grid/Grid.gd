extends TileMap

enum CellType { ACTOR, OBSTACLE, OBJECT }
export(NodePath) var dialogue_ui

func get_cell_entity(cell):
	for entity in get_children():
		if world_to_map(entity.position) == cell:
			return(entity)


func request_move(entity, direction):
	var cell_start = world_to_map(entity.position)
	var cell_target = cell_start + direction

	var cell_tile_id = get_cellv(cell_target)
	var tileData = tile_set.getTileData(cell_tile_id)
	if tileData["is_blocking"]:
		return
	
	var target_entity = get_cell_entity(cell_target)
	if target_entity:
		print("Cell %s contains %s" % [cell_target, target_entity.name])

		if not target_entity.has_node("DialoguePlayer"):
			print("target has no dialog")
			return
		get_node(dialogue_ui).show_dialogue(entity, target_entity.get_node("DialoguePlayer"))
		return

	return map_to_world(cell_target)
		
