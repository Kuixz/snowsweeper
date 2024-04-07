extends Node

const SIZE = 4

var lives = 3:
	set(value):
		lives = value
		if ui: ui.update_lives(lives)
var score = 0:
	set(value):
		score = value
		if ui: ui.update_score(score)
var flags = 25:
	set(value):
		flags = value
		if ui: ui.update_flags(flags)

var ui: UILayer = null

#region Compression
func compress() -> Dictionary:
	return {
		"lives": lives,
		"score": score,
		"flags": flags,
	}

func decompress(dict: Dictionary):
	lives = dict["lives"]
	score = dict["score"]
	flags = dict["flags"]
#endregion

func set_ui(u: UILayer):
	ui = u
	#u.init()
