extends GridLayer
class_name BuildPreview



@export var building_data: BuildingData

var in_build_preview: bool = false  # true  # false
var mouse_loc: Vector2i = Vector2i(0,0)
var placeable: bool = true

# Temporary
var placing: String = "BldgFlag1"
var dimensions: Vector2i = Vector2i(1,1)
var offset: Vector2i
#var size_length = 3

func screen_to_cell(loc: Vector2) -> Vector2i:
	return get_parent().screen_to_cell(loc)

func handle_left_click(loc: Vector2i) -> bool:
	if not in_build_preview: return false
	print("Place attempt")
	if placeable: 
		print("Placeable; checking inventory")
		if declare_construction(placing, loc - offset):
			recolor(loc)
	else: 
		print("Not Placeable")
	
	return true

func handle_mouse_motion(raw_loc: Vector2) -> bool:
	#if not in_build_preview: return false
	#
	#var new_loc = screen_to_cell(raw_loc)
	#if new_loc == mouse_loc: return true
	
	var new_loc = screen_to_cell(raw_loc)
	if new_loc == mouse_loc: return in_build_preview
	mouse_loc = new_loc
	
	if not in_build_preview: return false
	
	recolor(mouse_loc)
	return true



func toggle_build_preview():
	set_build_preview(not in_build_preview)

func set_build_preview(enabled: bool, building: String = placing):
	in_build_preview = enabled
	if enabled:
		#var loc = mouse_loc
		#var loc = screen_to_cell(Camera.get_mouse_position())
		#dimensions = res.get_dimensions(building)
		dimensions = building_data.get_dimensions(building)
		#recolor(loc)
		recolor(mouse_loc)
	else:
		reset()

func declare_construction(building: String, loc: Vector2i) -> bool:
	var recipe = building_data.get_cost(building)
	if Inventory.can_afford(recipe):
		print("Afforded")
		Inventory.debit(recipe)
		get_parent().construct(building, loc)
		return true
	print("Not Afforded")
	return false

func recolor(loc: Vector2i):
	#var leftx = (dimensions[0] - 1) / 2
	#var rightx = (dimensions[0]) / 2
	#var lefty = (dimensions[1] - 1) / 2
	#var righty = (dimensions[1]) / 2
	offset = (0.5) * dimensions
	#print(left)
	#print(right)
	reset()
	var all_vacant = true
	for dy in range(-offset.x, dimensions.x - offset.x):
		for dx in range(-offset.y, dimensions.y - offset.y):
			var at = loc + Vector2i(dx, dy)
			pass
			
			var minefield_cell = cell_at_in(at, "minefield")
			var town_cell = cell_at_in(at, "town")
			#var vacant = minefield_cell != null and not minefield_cell.is_mine and minefield_cell.is_revealed and town_cell == null
			var vacant = minefield_cell != null and minefield_cell.resource == 0 and minefield_cell.is_revealed and town_cell == null
			all_vacant = all_vacant and vacant
			register_cell(at).indicate(vacant)
	
	placeable = all_vacant
