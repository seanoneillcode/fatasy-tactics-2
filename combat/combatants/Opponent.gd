extends Combatant

func take_turn():
	$Timer.start()
	yield($Timer, "timeout")
	self.isDone = true
	emit_signal("turn_finished")

#func set_active(value):
#	if not $Timer.is_inside_tree():
#		return
#	$Timer.start()
#	yield($Timer, "timeout")
#	var target
#	for actor in get_parent().get_children():
#		if not actor == self:
#			target = actor
#			break
#	attack(target)
