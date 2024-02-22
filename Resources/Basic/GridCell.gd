extends Sprite2D 
class_name GridCell

const SIZE = 4
@export var res: GridResource

#region Compression
func compress() -> Dictionary:
	push_warning("Compress not implemented, using default")
	var dict = {}
	for property in get_script().get_script_property_list():
		dict[property.name] = property.value
	return dict

func decompress(loc: Vector2i, dict: Dictionary):
	push_warning("Decompress not implemented, using default")
	for key in dict.keys():
		self["key"] = dict[key]
	goto(loc)
#endregion

func goto(loc):
	scale = Vector2(SIZE, SIZE)
	position = loc * 16 * SIZE

func set_costume(costume_name:String):
	texture = res.textures[costume_name]
