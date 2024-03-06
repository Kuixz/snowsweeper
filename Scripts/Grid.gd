extends CompressibleNode
class_name Grid

signal update(what:Update)
enum Update { EXPLODE, OPEN, FLAG, UNFLAG }

#@export var res: MinefieldResources

@onready var minefield: Minefield = $Minefield
@onready var town: Town = $Town

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

func screen_to_cell(event, camera) -> Vector2i:
	var rect = get_viewport().get_visible_rect()
	var worldX = event.x - rect.size.x / 2 + camera.x
	var worldY = event.y - rect.size.y / 2 + camera.y
	return Vector2i(round(worldX / (16 * GridCell.SIZE)), round(worldY / (16 * GridCell.SIZE)))

func handle_left_click(loc: Vector2i):
	if town.handle_left_click(loc): return
	minefield.handle_left_click(loc)

func handle_right_click(loc: Vector2i):
	if town.handle_right_click(loc): return
	minefield.handle_right_click(loc)

func cell_at_in(loc: Vector2i, layer: String) -> GridCell:
	var l = self[layer]
	if not l.has(loc): return null
	return l.cell_at(loc)

func _on_minefield_update(what):
	emit_signal("update", what)

func _on_town_update(what):
	emit_signal("update", what)
