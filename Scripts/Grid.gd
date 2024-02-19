extends Node
class_name Grid

signal explosion

enum CellState { UNKNOWN, EMPTY, MINE }
#var sample_board = {
#	Vector2i(-2,-2): CellState.MINE,
#	Vector2i(-2,-1): CellState.MINE,
#	Vector2i(-2,0): CellState.MINE,
#	Vector2i(-2,1): CellState.MINE,
#	Vector2i(-2,2): CellState.MINE,
#	Vector2i(-1,2): CellState.MINE,
#	Vector2i(0,2): CellState.MINE,
#	Vector2i(1,2): CellState.MINE,
#	Vector2i(2,2): CellState.MINE,
#	Vector2i(2,1): CellState.MINE,
#	Vector2i(2,0): CellState.MINE,
#	Vector2i(2,-1): CellState.MINE,
#	Vector2i(2,-2): CellState.MINE,
#	Vector2i(1,-2): CellState.MINE,
#	Vector2i(0,-2): CellState.MINE,
#	Vector2i(-1,-2): CellState.MINE,
#
#	Vector2i(-1,-1): CellState.EMPTY,
#	Vector2i(-1,0): CellState.EMPTY,
#	Vector2i(-1,1): CellState.EMPTY,
#	Vector2i(0,-1): CellState.EMPTY,
#	Vector2i(0,0): CellState.EMPTY,
#	Vector2i(0,1): CellState.EMPTY,
#	Vector2i(1,-1): CellState.EMPTY,
#	Vector2i(1,0): CellState.EMPTY,
#	Vector2i(1,1): CellState.EMPTY,
#}
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
#var hoveringCell: Cell

@export var res: CellSharedResources

var cell_scene = preload("res://Scenes/cell.tscn")
var cell_map = {}
var pristine: bool = true


const RAD = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-RAD, RAD):
		for y in range(-RAD, RAD):
			instantiate_cell(Vector2i(x,y))

func instantiate_cell(loc: Vector2i):
	var child = cell_scene.instantiate()
	child.init(loc)
#	child.mouse_entered_cell.connect(_on_mouse_entered_cell)
#	child.click.connect(_on_mouse_click)
	cell_map[loc] = child
	add_child(child)
	return child

func getOrNewCell(loc: Vector2i):
	if cell_map.has(loc): return cell_map[loc]
	return instantiate_cell(loc)

func screen_to_cell(event, camera) -> Vector2i:
	var rect = get_viewport().get_visible_rect()
	var worldX = event.x - rect.size.x / 2 + camera.x
	var worldY = event.y - rect.size.y / 2 + camera.y
	return Vector2i(round(worldX / (16 * res.SIZE)), round(worldY / (16 * res.SIZE)))

func create_landing_area(loc: Vector2i):
	for offsetx in range(-2,3):
		for offsety in range(-2,3):
			getOrNewCell(loc + Vector2i(offsetx, offsety)).is_mine = false

#func _input(event):
#	if event is InputEventMouseButton and event.pressed:
#		var loc = screen_to_cell(event, $Camera)
#		# print(loc)
#		# var loc = Vector2i(cellX, cellY)
#		var locCell = getOrNewCell(loc)
#		if event.is_action_pressed("left_click"):
#			if pristine:
#				create_landing_area(loc)
#				pristine = false
#
#			if locCell.is_flagged: return
#
#			if locCell.is_mine: 
#				locCell.set_costume('mine')
#			else: 
#				if not locCell.is_revealed:
#					flood_fill(loc)
#				# locCell.set_costume('mine')
#				# oh no! you lost a heart
#
#		elif event.is_action_pressed('right_click'):
#			if not locCell.is_revealed:
#				locCell.toggle_flagged()
#	#		print(hoveringCell.data.number)

func reveal_at(locCell: Cell) -> int:
	if locCell.is_flagged: return 0
	if locCell.is_revealed: return 0
	
	if pristine:
		create_landing_area(locCell.cellXY)
		pristine = false
	
	if locCell.is_mine: 
		locCell.explode()
		return -1
	else: 
		flood_fill(locCell.cellXY)
		return 0

func handle_right_click(locCell: Cell, flags: int) -> int:
	if locCell.is_revealed: return 0
	if locCell.is_flagged: locCell.set_flagged(false); return -1
	if flags == 0: return 0
	locCell.set_flagged(true); return 1
#	if not locCell.is_revealed:
#		return locCell.toggle_flagged()

func flood_fill(location: Vector2i):
	var queue = [location]
	var seen = { location: null }  # Set
#	const max_queue_size = 60  # 20 is quite low, outlier probabilities considered. Try 60 or unbounded.
	while len(queue) > 0:
#		print(len(queue))
		var next = queue.pop_front()
		var nextCell = cell_map[next];  # nextCell.is_revealed = true
		var neighbors = offsets.map(func(offset): return Vector2i(offset.x + next.x, offset.y + next.y))
		var mineCount = neighbors.map(func(neighbor): return getOrNewCell(neighbor).is_mine).count(true)
#		if (mineCount != 0):
#			if nextCell.resource == -1: 
#				nextCell.openTo(mineCount)
#				nextCell.resource = mineCount
#				nextCell.set_costume(str(mineCount))  # Technically not necessary, if i remove the typecheck on the other side...
#		else:
			# nextCell.set_costume('open')
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
