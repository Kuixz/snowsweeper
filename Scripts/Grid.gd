extends Node

enum CellState { UNKNOWN, EMPTY, MINE }
var board = {
	Vector2i(-2,-2): CellState.MINE,
	Vector2i(-2,-1): CellState.MINE,
	Vector2i(-2,0): CellState.MINE,
	Vector2i(-2,1): CellState.MINE,
	Vector2i(-2,2): CellState.MINE,
	Vector2i(-1,2): CellState.MINE,
	Vector2i(0,2): CellState.MINE,
	Vector2i(1,2): CellState.MINE,
	Vector2i(2,2): CellState.MINE,
	Vector2i(2,1): CellState.MINE,
	Vector2i(2,0): CellState.MINE,
	Vector2i(2,-1): CellState.MINE,
	Vector2i(2,-2): CellState.MINE,
	Vector2i(1,-2): CellState.MINE,
	Vector2i(0,-2): CellState.MINE,
	Vector2i(-1,-2): CellState.MINE,
	
	Vector2i(-1,-1): CellState.EMPTY,
	Vector2i(-1,0): CellState.EMPTY,
	Vector2i(-1,1): CellState.EMPTY,
	Vector2i(0,-1): CellState.EMPTY,
	Vector2i(0,0): CellState.EMPTY,
	Vector2i(0,1): CellState.EMPTY,
	Vector2i(1,-1): CellState.EMPTY,
	Vector2i(1,0): CellState.EMPTY,
	Vector2i(1,1): CellState.EMPTY,
}
var hoveringCell: Cell

var cell_scene = preload("res://Scenes/cell.tscn")
var cell_map = {}
@export var res: CellSharedResources

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-5, 5):
		for y in range(-5, 5):
			instantiate_cell(x,y)

func instantiate_cell(x: int,y: int):
	var child = cell_scene.instantiate()
	child.init(x,y)
#	child.mouse_entered_cell.connect(_on_mouse_entered_cell)
#	child.click.connect(_on_mouse_click)
	cell_map[Vector2i(x,y)] = child
	add_child(child)
	
func _input(event):
	if (event is InputEventMouseButton and event.pressed):
		# screen to world coordinates
		
#		var cellX = round((event.position.x - $Camera.position.x) / res.SIZE)
#		var cellY = round((event.position.y - $Camera.position.y) / res.SIZE)
		var cellX = round((event.position.x + $Camera.position.x) / (16 * res.SIZE)) - 9
		var cellY = round((event.position.y + $Camera.position.y) / (16 * res.SIZE)) - 5
		# Why the fuck do I need to adjust by (-9, -5)?
		hoveringCell = cell_map[Vector2i(cellX, cellY)]

		# determine clicked cell
		pass
		
		print("click at ", hoveringCell.cellX, ",", hoveringCell.cellY)
#
		hoveringCell.set_costume('open')
#		print(hoveringCell.data.number)

#func _on_mouse_click(s):
#	hoveringCell = s

#func _on_mouse_entered_cell(s):
#	hoveringCell = s
#	print(s.cellX)
