extends CompressibleNode
class_name GridLayer

var cell_map = {}

@onready var cell: GridCell = $Cell

#region Compression
func compress() -> Dictionary:
	return {
		"cell_map": cell_map.keys().map(func (key): return [key.x, key.y, cell_map[key].compress()]), 
	}

func decompress(dict: Dictionary):
	for arr in dict["cell_map"]:
		var loc = Vector2i(arr[0],arr[1])
		instantiate_cell(loc).decompress(loc, arr[2])
#endregion

#region Control
## Handles a left click on this layer.
## @param loc: Vector2i -> The grid location clicked.
## @return bool -> Whether or not the click was intercepted on this layer.
func handle_left_click(loc: Vector2i) -> bool:
	return false

## Handles a right click on this layer.
## @param loc: Vector2i -> The grid location clicked.
## @return bool -> Whether or not the click was intercepted on this layer.
func handle_right_click(loc: Vector2i) -> bool:
	return false
#endregion

func instantiate_cell(loc: Vector2i) -> GridCell:
	var child = $Cell.duplicate(); child.visible = true  # cell_scene.instantiate()
	set_cell(loc, child)
	add_child(child)
	return child
	
func get_or_new_cell(loc: Vector2i):
	if has(loc): return cell_at(loc)
	return instantiate_cell(loc)
	
func has(loc: Vector2i):
	return cell_map.has(loc)

func set_cell(loc: Vector2i, value):
	cell_map[loc] = value

func cell_at(loc: Vector2i):
	return cell_map[loc]

func erase(loc: Vector2i):
	cell_map.erase(loc)
