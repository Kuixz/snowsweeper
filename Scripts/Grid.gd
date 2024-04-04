extends CompressibleNode
class_name Grid

signal update(what:Update)
enum Update { EXPLODE, OPEN, FLAG, UNFLAG }

#@export var res: MinefieldResources

@onready var minefield: Minefield = $Minefield
@onready var town: Town = $Town
@onready var build_preview: BuildPreview = $BuildPreview

#region Compression
func compress() -> Dictionary:
	return {
		"minefield": minefield.compress(),
		"town": town.compress()
	}

func decompress(dict: Dictionary):
	if dict.has("minefield"): minefield.decompress(dict["minefield"])
	if dict.has("town"): town.decompress(dict["town"])
#endregion



func screen_to_cell(loc) -> Vector2i:
	var world = Camera.screen_to_world(loc)
	return Vector2i(round(world.x / (16 * GridCell.SIZE)), round(world.y / (16 * GridCell.SIZE)))

#func screen_to_half_cell(loc, camera) -> Vector2i:
	#return screen_to_cell(loc - Vector2(8 * GridCell.SIZE, 8 * GridCell.SIZE), camera)
	
	#var world = camera.screen_to_world(loc)
	#const offset = Vector2(8 * GridCell.SIZE, 8 * GridCell.SIZE)
	#return screen_to_cell(loc - offset, camera)
	
	#var world = camera.screen_to_world(loc)
	#var g = Vector2i(world)
	#print(g)
	#return g

func cell_at_in(loc: Vector2i, layer: String) -> GridCell:
	var l = self[layer]
	if not l.has(loc): return null
	return l.cell_at(loc)

func handle_left_click(raw_loc: Vector2):
	var loc = screen_to_cell(raw_loc)
	if build_preview.handle_left_click(loc): return
	if town.handle_left_click(loc): return
	minefield.handle_left_click(loc)

func handle_right_click(raw_loc: Vector2):
	var loc = screen_to_cell(raw_loc)
	if town.handle_right_click(loc): return
	minefield.handle_right_click(loc)

func handle_mouse_motion(raw_loc: Vector2):
	#if not in_build_preview: return
	if build_preview.handle_mouse_motion(raw_loc): return



#func start_build():
	#in_build_preview = true
#
#func stop_build():
	#in_build_preview = false



func _on_minefield_update(what):
	emit_signal("update", what)

func _on_town_update(what):
	emit_signal("update", what)
