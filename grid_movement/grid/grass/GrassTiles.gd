

var data = {
	-1: {
		"is_blocking": true
	},
	0: {
		"is_blocking": true
	},
	1: {
		"is_blocking": true
	},
	2: {
		"is_blocking": true
	},
	3: {
		"is_blocking": true
	},
	4: {
		"is_blocking": true
	},
	5: {
		"is_blocking": true
	},
	6: {
		"is_blocking": true
	},
	7: {
		"is_blocking": true
	},
	8: {
		"is_blocking": true
	},
	9: {
		"is_blocking": false
	},
	10: {
		"is_blocking": false
	},
	11: {
		"is_blocking": false
	},
	12: {
		"is_blocking": false
	},
	13: {
		"is_blocking": false
	},
	14: {
		"is_blocking": false
	}
}

func getTileData(id):
	if data.has(id):
		return data[id]
	return data[-1]
