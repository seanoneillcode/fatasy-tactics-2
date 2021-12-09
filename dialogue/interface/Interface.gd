extends Control

var dialogue_node = null

func _ready():
	hide()

func show_dialogue(player, dialogue):
	show()
	$Button.grab_focus()
	dialogue_node = dialogue
	dialogue_node.connect("dialogue_finished", self, "_on_dialogue_finished", [player])

	player.set_active(false)
	dialogue_node.start_dialogue()
	updateText()


func _on_Button_button_up():
	dialogue_node.next_dialogue()
	updateText()

func updateText():
	if !dialogue_node:
		return
	$Name.text = dialogue_node.dialogue_name
	$Text.text = dialogue_node.dialogue_text

func _on_dialogue_finished(player):
	player.set_active(true)
	dialogue_node.disconnect("dialogue_finished", self, "_on_dialogue_finished")
	hide()
