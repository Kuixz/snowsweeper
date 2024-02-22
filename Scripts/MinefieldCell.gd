extends GridCell

#signal click(s)
#signal mouse_entered_cell(s)

#const SIZE: int = 4
var is_mine: bool
var is_revealed: bool = false
var is_flagged: bool = false
var resource: int = -1
#var data: CellData

#@export var keeper: CellKeeper
#@export var res: MinefieldResources


#region Compression
func compress() -> Dictionary:
	return {
		"is_mine": is_mine,
		"is_revealed": is_revealed,
		"is_flagged": is_flagged,
		"resource": resource
	}

func decompress(loc: Vector2i, dict: Dictionary):
	is_mine = dict["is_mine"]
	is_revealed = dict["is_revealed"]
	is_flagged = dict["is_flagged"]
	resource = dict["resource"]
	goto(loc)
	
	if is_flagged: set_costume('flag'); return
	if not is_revealed: set_costume('closed'); return
	if is_mine: set_costume('mine'); return
	set_costume(str(resource))
#endregion

func generate(loc):
	is_mine = randf() < 0.25  # 0.15
	goto(loc)
	
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

func explode():
	is_revealed = true
	set_costume('mine')

func openTo(count: int):
	if resource != -1: return
	is_revealed = true
	resource = count
	set_costume(str(count)) # Technically not necessary, if i remove the typecheck on the other side...

func set_flagged(f: bool):
	is_flagged = f
	set_costume('flag' if f else 'closed')
