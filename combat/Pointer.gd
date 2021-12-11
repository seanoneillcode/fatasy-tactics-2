extends Node2D

var entity

func _ready():
	hide()

func _process(delta):
	if entity:
		position.x = entity.position.x
		position.y = entity.position.y - 16

func set_entity(entity):
	if not entity:
		hide()
	else:
		show()
	self.entity = entity
