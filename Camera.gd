extends Camera2D


var follow_node


func set_follow_node(node):
	follow_node = node
	if not follow_node:
		position = Vector2()


func _process(delta):
	if follow_node:
		position.x = follow_node.position.x - offset.x + 8
		position.y = follow_node.position.y - offset.y + 8
