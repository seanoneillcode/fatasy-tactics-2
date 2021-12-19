class_name Combatant
extends Node2D


export(int) var damage = 1
export(int) var defense = 1
export var team = "a"
var moves = 3
signal turn_finished

var target_position = Vector2()
var moving = false
var move_time = 0.0
var move_amount = 0.0

export var abilities = ["skip", "cancel"]

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
	emit_signal("turn_finished")


func consume(item):
	item.use(self)
	emit_signal("turn_finished")


func defend():
	$Health.armor += defense
	emit_signal("turn_finished")


func flee():
	emit_signal("turn_finished")


func take_damage(damage_to_take):
	$Health.take_damage(damage_to_take)
	$Sprite/AnimationPlayer.play("take_damage")


	
