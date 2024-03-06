extends GridLayer
class_name Minefield

signal update(what: Grid.Update)
const offsets = [
	Vector2i(-1,-1),
	Vector2i(-1,0),
	Vector2i(-1,1),
	Vector2i(0,-1),
	Vector2i(0,0),
	Vector2i(0,1),
	Vector2i(1,-1),
	Vector2i(1,0),
	Vector2i(1,1),
]

#@export var state: GameState

var pristine: bool = true

#region Compression
func compress() -> Dictionary:
	var dict = super.compress()
	dict["pristine"] = pristine
	return dict

func decompress(dict: Dictionary):
	super.decompress(dict)
	pristine = dict["pristine"]
#endregion

#region Control
func handle_left_click(loc: Vector2i):
	if has(loc):
		var locCell = cell_at(loc)
		#if locCell.is_flagged:  # NOTE: This case is handled in Town.
			#print("This is a flag")
			#returna
		if locCell.is_revealed: 
			print("This is a " + str(locCell.resource))
			return
	
	if Global.lives == 0: return
	
	var locCell = get_or_new_cell(loc)
	if pristine:
		create_landing_area(loc)
		pristine = false
		
	if locCell.is_mine: 
		locCell.explode()
		emit_signal("update", Grid.Update.EXPLODE)  # TODO
	else: 
		flood_fill(loc)
		emit_signal("update", Grid.Update.OPEN)  # TODO

func handle_right_click(loc: Vector2i):  # TODO move this logic to Town? Or only store the special flags there?
	if not has(loc): return
	
	var locCell = get_or_new_cell(loc)
	if locCell.is_revealed: return
	if locCell.is_flagged: 
		locCell.set_flagged(false); 
		emit_signal("update", Grid.Update.UNFLAG)  # TODO
		#Global.flags += 1
		return
	if Global.flags == 0: return
	locCell.set_flagged(true)
	emit_signal("update", Grid.Update.FLAG)  # TODO
	#Global.flags -= 1
#endregion

#func register_cell(loc: Vector2i) -> GridCell:
	#var child = super.register_cell(loc)
	##child.generate()
	#return child

func create_landing_area(loc: Vector2i):
	for offsetx in range(-2,3):
		for offsety in range(-2,3):
			get_or_new_cell(loc + Vector2i(offsetx, offsety)).is_mine = false

func flood_fill(location: Vector2i):
	var queue = [location]
	var seen = { location: null }  # Set
#	const max_queue_size = 60  # 20 is quite low, outlier probabilities considered. Try 60 or unbounded.
	while len(queue) > 0:
#		print(len(queue))
		var next = queue.pop_front()
		var nextCell = cell_at(next);  # nextCell.is_revealed = true
		var neighbors = offsets.map(func(offset): return Vector2i(offset.x + next.x, offset.y + next.y))
		var mineCount = neighbors.map(func(neighbor): return get_or_new_cell(neighbor).is_mine).count(true)

		nextCell.openTo(mineCount)
		if (mineCount == 0):
			for neighbor in neighbors:
				if not seen.has(neighbor):
					queue.push_back(neighbor)
					seen[neighbor] = null
#			if len(queue) > max_queue_size: push_error("Queue size exceeded (%s > %s)" % [len(queue), max_queue_size])


#func _on_mouse_click(s):
#	hoveringCell = s

#func _on_mouse_entered_cell(s):
#	hoveringCell = s
#	print(s.cellX)
