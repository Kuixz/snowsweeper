extends GridLayer
class_name BuildPreview

var in_build_preview: bool = false  # true  # false
var previous_mouse_loc: Vector2i = Vector2i(0,0)
var placeable: bool = true

# Temporary
var size_length = 3

func handle_left_click(loc: Vector2i) -> bool:
	if not in_build_preview: return false
	print("Place attempt")
	if placeable: print("Success")
	else: print("Failure")
	
	return true

func handle_mouse_motion(raw_loc: Vector2) -> bool:
	if not in_build_preview: return false
	
	var loc = get_parent().screen_to_cell(raw_loc)
	if loc == previous_mouse_loc: return true
	
	previous_mouse_loc = loc
	#print(loc)
	recolor(loc)
	return true



func toggle_build_preview():
	set_build_preview(not in_build_preview)

func set_build_preview(enabled: bool):
	in_build_preview = enabled
	if enabled:
		var raw_loc = Camera.get_mouse_position()
		recolor(get_parent().screen_to_cell(raw_loc))
	else:
		reset()

func recolor(loc: Vector2i):
	var left = (size_length - 1) / 2
	var right = (size_length) / 2
	#print(left)
	#print(right)
	reset()
	var all_vacant = true
	for dy in range(-left, right + 1):
		for dx in range(-left, right + 1):
			var at = loc + Vector2i(dx, dy)
			pass
			
			var minefield_cell = cell_at_in(at, "minefield")
			var town_cell = cell_at_in(at, "town")
			#var vacant = minefield_cell != null and not minefield_cell.is_mine and minefield_cell.is_revealed and town_cell == null
			var vacant = minefield_cell != null and minefield_cell.resource == 0 and minefield_cell.is_revealed and town_cell == null
			all_vacant = all_vacant and vacant
			register_cell(at).indicate(vacant)
	
	placeable = all_vacant
