extends Resource
class_name CellKeeper

var map: Dictionary = {}  # Dictionary<Vector2i, CellData>

func get_or_else(dict:Dictionary, key, default):
	if (dict.has(key)): return dict[key]
	return default

func get_cell(x:int, y:int) -> CellData:
	return get_or_else(map, Vector2i(x,y), CellData.new())
	
#	push_error('not implemented')
#	return

func set_cell(x:int, y:int, cd: CellData):
	map[Vector2i(x, y)] = cd
	
#	push_error('not implemented')
#	return 
