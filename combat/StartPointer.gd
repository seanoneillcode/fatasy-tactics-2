extends Node2D

var entity

func _ready():
	hide()

func _process(delta):
	if entity:
		position.x = entity.start_pos.x
		position.y = entity.start_pos.y

func set_entity(entity):
	if not entity:
		hide()
	else:
		show()
	self.entity = entity
