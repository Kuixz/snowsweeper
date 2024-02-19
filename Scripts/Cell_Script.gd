extends Sprite2D
class_name Cell

#signal click(s)
#signal mouse_entered_cell(s)

#const SIZE: int = 4
var cellXY: Vector2i
var is_mine: bool
var is_revealed: bool = false
var is_flagged: bool = false
var resource: int = -1

#var data: CellData

#@export var keeper: CellKeeper
@export var res: CellSharedResources

# Called when the node enters the scene tree for the first time.
func init(loc: Vector2i):
	cellXY = loc
	is_mine = randf() < 0.25  # 0.15
	scale = Vector2(res.SIZE, res.SIZE)
	position = Vector2(loc.x * 16 * res.SIZE, loc.y * 16 * res.SIZE)
	
#	data = keeper.get_cell(x, y)
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
	texture = res.textures[costume_name]

func explode():
	is_revealed = true
	set_costume('mine')

func openTo(count: int):
	if resource != -1: return
	is_revealed = true
	resource = count
	if count == 0: set_costume('open')
	else: set_costume(str(count)) # Technically not necessary, if i remove the typecheck on the other side...

func set_flagged(f: bool):
	is_flagged = f
	set_costume('flag' if f else 'closed')
