extends Area2D
class_name Cell

#signal click(s)
#signal mouse_entered_cell(s)

const SIZE: int = 4
var cellX: int = 0
var cellY: int = 0

var data: CellData

@export var keeper: CellKeeper
@export var res: CellSharedResources

# Called when the node enters the scene tree for the first time.
func init(x:int, y:int):
	cellX = x
	cellY = y
	scale = Vector2(res.SIZE, res.SIZE)
	position = Vector2(x * 16 * res.SIZE, y * 16 * res.SIZE)
	
	data = keeper.get_cell(x, y)
#	$Sprite2D.texture = resources.textures[data.]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _on_mouse_entered():
#	mouse_entered_cell.emit(self)# Replace with function body.

#func _input(event):
#	if(event is InputEventMouseButton and event.pressed):
#		click.emit(self)# Replace with function body.

func set_costume(costume_name:String):
	$Sprite2D.texture = res.textures[costume_name]
