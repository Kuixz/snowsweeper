extends TimeoutSetter 
class_name GridCell

const SIZE = 4
var sprite: Sprite2D
var res: GridResource

#region Compression
func compress() -> Dictionary:
	#push_warning("Compress not implemented, using default")
	var dict = {}
	for property in get_script().get_script_property_list():
		dict[property.name] = property.value
	return dict

func decompress(dict: Dictionary):
	#push_warning("Decompress not implemented, using default")
	for key in dict.keys():
		if key == "pending_timeouts":
			decompress_timeouts(dict["pending_timeouts"])
		else: self[key] = dict[key]
	#goto(loc)
	#if dict.has("pending_timeouts"): decompress_timeouts(dict["pending_timeouts"])
#endregion

func _ready():
	res = get_parent().res
	sprite = Sprite2D.new()
	#sprite.visible = false
	add_child(sprite)
	if res.textures.has("default"): sprite.texture = res.textures["default"]

func goto(loc: Vector2i):
	sprite.scale = Vector2(SIZE, SIZE)
	sprite.position = loc * 16 * SIZE
	#sprite.visible = true 

func set_costume(costume_name:String):
	sprite.texture = res.textures[costume_name]
