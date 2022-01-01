extends Node


func get_action_data(action):
	match action:
		"strike":
			return {
				"min_range": 1,
				"max_range": 1
			}
		"heal":
			return {
				"min_range": 0,
				"max_range": 0
			}
		"fireball":
			return {
				"min_range": 2,
				"max_range": 5
			}
