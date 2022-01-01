class_name Combatant
extends Node2D


export(int) var damage = 1
export(int) var defense = 1
export var team = "a"
var moves = 3
signal turn_finished
var isDone = false

var target_position = Vector2()
var start_pos = Vector2()
var moving = false
var move_time = 0.0
var move_amount = 0.0

export var abilities = ["done"]

var state = ""

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


func move(target_position, direction):
	if moving:
		return
	moving = true
	move_time = 0.0
	self.target_position = target_position
	self.move_amount = direction * 16 / 0.2


func attack(target):
	target.take_damage(damage)
	end_turn()


func consume(item):
	item.use(self)
	end_turn()


func defend():
	$Health.armor += defense
	end_turn()


func flee():
	end_turn()


func next_combatant():
	emit_signal("turn_finished")


func apply_damage(amount):
	$Health.take_damage(amount)
	$Sprite/AnimationPlayer.play("take_damage")
	end_turn()


func end_turn():
	self.isDone = true
	emit_signal("turn_finished")
	
