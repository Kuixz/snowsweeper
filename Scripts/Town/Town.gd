extends GridLayer
class_name Town

signal update(what: Grid.Update)

#@export var state: GameState
#@export var res: TownResources

var block_list = []  # [Vector2i, GridCell]
var global_building_id: int = -1

#region Compression
func compress() -> Dictionary:
	return {
		"block_list": block_list.map(func(item) : return [item[0].x, item[0].y, item[1].compress()]),
		#"global_building_id": global_building_id
		#"cell_map": cell_map.keys().map(func (key): return [key.x, key.y, cell_map[key].compress()]), 
	}
func decompress(dict: Dictionary):
	#global_building_id = dict["global_building_id"]
	for arr in dict["block_list"]:
		var subclass = arr[2]["subclass"]
		arr[2].erase("subclass")
		var loc = Vector2i(arr[0],arr[1])
		#register_cell(loc).decompress(loc, arr[2])
		#arr[2]["loc"] = loc
		register_cell_oftype(subclass, loc).decompress(arr[2])
#endregion

func register_cell_oftype(subclass: String, loc: Vector2i) -> GridCell:
	var child = super.register_cell_oftype(subclass, loc)
	global_building_id += 1
	block_list.push_back([loc, child])
	for x in range(0, child.width):
		for y in range(0, child.height):
			set_cell_at(loc + Vector2i(x, y), global_building_id)
	return child

func cell_at(loc: Vector2i) -> GridCell:
	return block_list[cell_map[loc]][1]

func erase(loc: Vector2i):
	var index = cell_map[loc]
	var cell = block_list[index][1]
	for x in range(0, cell.width):
		for y in range(0, cell.height):
			cell_map.erase(loc + Vector2i(x,y))
	block_list[index] = null  # Danger?

func handle_left_click(loc: Vector2i) -> bool:
	if has(loc):
		cell_at(loc).on_click()
		return true
	
	var underlying = cell_at_in(loc, "minefield")
	if underlying and underlying.is_flagged: 
		print("you clicked a flag: UPGRADE IT")
		return true
	return false

func handle_right_click(loc: Vector2i) -> bool:
	#if not has(loc):
		#register_cell_oftype("Flag", loc)
	#var cell = cell_at(loc)
	#if cell is Flag:
		#erase(cell)
	#return true
	#print("Placed BdlgFlag1 at %s" % str(loc))
	#var cell = 
	#register_cell_oftype("BldgFlag1", loc).init()
	#cell.init()
	return false













