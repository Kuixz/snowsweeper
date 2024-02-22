extends CompressibleNode
class_name Grid

signal update(what:Update)
enum Update { EXPLODE, OPEN, FLAG, UNFLAG }

@onready var town: Town = $Town

@export var res: MinefieldResources
@onready var minefield: Minefield = $Minefield

#region Compression
func compress() -> Dictionary:
	return {
		"minefield": minefield.compress()
	}

func decompress(dict: Dictionary):
	if dict.has("minefield"): minefield.decompress(dict["minefield"])
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

func _on_minefield_update(what):
	emit_signal("update", what)
