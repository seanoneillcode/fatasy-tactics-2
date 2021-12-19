extends VBoxContainer




func set_items(items):
	var children = self.get_children()
	for child in children:
		child.visible = false
	
	var index = 0
	for item in items:
		children[index].visible = true
		children[index].text = item
		index += 1
		if index == 5:
			break
		# create button
		# add it to self tree
	
	print("set items")
	children[0].grab_focus()

func get_current_action():
	var children = self.get_children()
	for child in children:
		if child.has_focus():
			return child.text
