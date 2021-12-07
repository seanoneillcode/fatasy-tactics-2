extends Pawn

onready var Grid = get_parent()
var lost = false

onready var tween = $Tween

func _process(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return

	var target_position = Grid.request_move(self, input_direction)
	if target_position:
		move_to(target_position)


func get_input_direction():
	var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical = 0
	if not horizontal:
		vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return Vector2(horizontal, vertical)

func move_to(target_position):
	set_process(false)
	
	tween.interpolate_property(self, "position", position, target_position, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	yield(tween, "tween_completed")
	set_process(true)
	

