extends CompressibleNode
class_name GridLayer

var cell_map = {}

#@onready var cell: GridCell = $Cell
@export var res: GridResource

#region Compression
func compress() -> Dictionary:
	return {
		"cell_map": cell_map.keys().map(func (key): return [key.x, key.y, cell_map[key].compress()]), 
	}

func decompress(dict: Dictionary):
	for arr in dict["cell_map"]:
		var loc = Vector2i(arr[0],arr[1])
		#register_cell(loc).decompress(loc, arr[2])
		arr[2]["loc"] = loc
		register_cell(loc).decompress(arr[2])
#endregion

#region Control
## Handles a left click on this layer.
## @param loc: Vector2i -> The grid location clicked.
## @return bool -> Whether or not the click was intercepted on this layer.
func handle_left_click(_loc: Vector2i) -> bool:
	return false

## Handles a right click on this layer.
## @param loc: Vector2i -> The grid location clicked.
## @return bool -> Whether or not the click was intercepted on this layer.
func handle_right_click(_loc: Vector2i) -> bool:
	return false
#endregion

#func inject_cell(loc: Vector2i, cell: GridCell):
	#cell_map[loc] = cell
	#add_child(cell)
	#cell.goto(loc)

func register_cell(loc: Vector2i) -> GridCell:
	return register_cell_oftype("default", loc)

func register_cell_oftype(subclass: String, loc: Vector2i) -> GridCell:
	var child = res.subclasses[subclass].new()
	cell_map[loc] = child
	add_child(child)
	child.goto(loc)
	return child

func get_or_new_cell(loc: Vector2i) -> GridCell:
	return get_or_new_cell_oftype("default", loc)
	
func get_or_new_cell_oftype(subclass: String, loc:Vector2i) -> GridCell:
	if has(loc): return cell_at(loc)
	return register_cell_oftype(subclass, loc)

func has(loc: Vector2i):
	return cell_map.has(loc)

func set_cell_at(loc: Vector2i, value):
	cell_map[loc] = value

func cell_at(loc: Vector2i):
	return cell_map[loc]
	
func cell_at_in(loc: Vector2i, layer: String) -> GridCell:
	return get_parent().cell_at_in(loc, layer)

func erase(loc: Vector2i):
	cell_map.erase(loc)

func reset():
	for cell in cell_map:
		cell_map[cell].queue_free()
	cell_map = {}
