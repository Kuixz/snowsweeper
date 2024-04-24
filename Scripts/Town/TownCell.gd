extends GridCell
#implements TimeoutSetter
class_name TownCell

#static var building_data: BuildingData
#var pending_timeouts = []

#var width: int = 1
#var height: int = 1
var subclass: String

#region Compression
func compress() -> Dictionary:
	var dict = {
		"subclass": subclass,
		#"pending_timeouts": pending_timeouts
	}
	if len(pending_timeouts) > 0: dict["pending_timeouts"] = pending_timeouts.map(func(x):return x.compress())
	return dict

#func decompress(dict: Dictionary):
	#super.decompress(dict)
	#for timeout in pending_timeouts:
		#print(timeout.batch_count)
	#if dict.has("pending_timeouts"): decompress_timeouts(dict["pending_timeouts"])

func _ready():
	res = get_parent().res
	sprite = Sprite2D.new()
	#sprite.visible = false
	add_child(sprite)
	if res.textures.has(subclass): sprite.texture = res.textures[subclass]
	elif res.textures.has("default"): sprite.texture = res.textures["default"]
#endregion

func goto(loc: Vector2i):
	var dimensions = get_parent().building_data.get_dimensions(subclass)  # TODO: Inappropriate coupling.
	sprite.scale = Vector2(SIZE/4, SIZE/4)  # Quarter length compensates for 4x resolution
	sprite.position = Vector2(loc.x + (dimensions.x - 1)/2, loc.y + (dimensions.y - 1)/2) * 16 * SIZE
	pass

#func sayhi(times: int):
	#for count in range(0, times):
		#print('hi')

func onclick():
	print("Onclick not implemented")
