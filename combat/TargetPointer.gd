extends Node2D

var target_position = Vector2()
var start_pos = Vector2()
var moving = false
var move_time = 0.0
var move_amount = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):	
	if moving:
		var speed = 1
		move_time += delta
		if move_time > 0.2:
			position = target_position
			moving = false
			move_time = 0.0
		else:
			position = position + (move_amount * delta)
			return


func move(direction):
	if moving:
		return
	moving = true
	move_time = 0.0
	self.target_position = position + (direction * 16)
	self.move_amount = direction * 16 / 0.2
