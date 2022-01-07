extends Control

var dialogue_node = null

func _ready():
	hide()

func show_dialogue(player, dialogue):
	show()
	$Button.grab_focus()
	dialogue_node = dialogue
	dialogue_node.connect("dialogue_finished", self, "_on_dialogue_finished", [player])
	$Button.connect("button_up", self, "_on_Button_button_up")

	player.set_active(false)
	dialogue_node.start_dialogue()
	updateText()


func _on_Button_button_up():
	print("button up")
	dialogue_node.next_dialogue()
	updateText()

func updateText():
	print("update text")
	if !dialogue_node:
		return
	if dialogue_node.dialogue_name != " ":
		$Name.text = dialogue_node.dialogue_name + ":"
	else:
		$Name.text = dialogue_node.dialogue_name
	
	$Text.text = dialogue_node.dialogue_text

func _on_dialogue_finished(player):
	print("dialog finished")
	player.set_active(true)
	dialogue_node.disconnect("dialogue_finished", self, "_on_dialogue_finished")
	hide()
