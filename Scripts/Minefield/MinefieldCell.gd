extends GridCell
class_name MinefieldCell

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

func decompress(dict: Dictionary):
	super.decompress(dict)
	#is_mine = dict["is_mine"]
	#is_revealed = dict["is_revealed"]
	#is_flagged = dict["is_flagged"]
	#resource = dict["resource"]
	#goto(loc)
	
	if is_flagged: set_costume('flag'); return
	if not is_revealed: set_costume('default'); return
	if is_mine: set_costume('mine'); return
	set_costume(str(resource))
#endregion

func _ready():
	super._ready()
	is_mine = randf() < 0.21 # 0.25
	#goto(loc)
	
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

func set_flagged(f: bool):  # TODO remove
	is_flagged = f
	set_costume('flag' if f else 'default')



func set_harvest():
	print("This is a " + str(resource))
	if resource > 0 and not has_timeout_of_method("harvest"):
		set_timeout("harvest", res.get_harvest_duration(resource))

func harvest(_cycles: int):
	print("Harvested a " + str(resource))
	#print(Inventory.table)
	Inventory.harvest(resource)
	#print(Inventory.counts)
	resource = 0
	set_costume('0')
