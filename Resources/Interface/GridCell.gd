extends BatchTimeoutSetter 
class_name GridCell

const SIZE = 4
var sprite: Sprite2D
var res: GridResource

var position: Vector2:
	set(pos):
		sprite.position = pos
	get:
		return sprite.position
var _scale: Vector2:
	set(sca):
		sprite.scale = sca
	get:
		return sprite.scale
var _texture: Texture2D:
	set(text):
		sprite.texture = text
	get:
		return sprite.texture

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
	if res.textures.has("default"): _texture = res.textures["default"]

func goto(loc: Vector2i):
	position = loc * 16 * SIZE
	_scale = Vector2(SIZE, SIZE)
	#sprite.visible = true 

func set_costume(costume_name:String):
	_texture = res.textures[costume_name]
