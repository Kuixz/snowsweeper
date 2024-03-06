extends GridCell
class_name TownCell

@onready var chronos = Chronos
var pending_timeouts = []

var width: int = 1
var height: int = 1
var subclass: String

#region Compression
func compress() -> Dictionary:
	var dict = {
		"subclass": subclass,
		#"pending_timeouts": pending_timeouts
	}
	if len(pending_timeouts) > 0: dict["pending_timeouts"] = pending_timeouts.map(func(x):return x.compress())
	return dict

func decompress(dict: Dictionary):
	if dict.has("pending_timeouts"): decompress_timeouts(dict["pending_timeouts"])

func _ready():
	res = get_parent().res
	sprite = Sprite2D.new()
	#sprite.visible = false
	add_child(sprite)
	if res.textures.has(subclass): sprite.texture = res.textures[subclass]
	elif res.textures.has("default"):  sprite.texture = res.textures["default"]
#endregion

#region Timeouts
func decompress_timeouts(arr: Array):
	for data in arr:
		var timeout = BatchTimeout.decompress(self, data)
		var elapsed = timeout.on_deserialize_rebatch(Chronos.current_time)
		timeout.callback(elapsed)
		if timeout.batch_count > 0:
			push_timeout(timeout)

func callback(timeout: BatchTimeout, cycles: int):
	var callable = Callable(self, timeout.method)
	#print(cycles)
	callable.call(cycles)
	if timeout.batch_count == 0:
		pending_timeouts.erase(timeout)

func push_timeout(timeout: BatchTimeout):
	Chronos.push_timeout(timeout)
	pending_timeouts.push_back(timeout)
	#Chronos.attach(self)
	print(pending_timeouts)
	
func set_timeout(method: String, seconds: float, batch_count: int = 1, category = "none"):
	var timeout = BatchTimeout.new(self, batch_count, seconds, Chronos.time() + seconds, method)
	push_timeout(timeout)
	
func rebatch_timeout(timeout: BatchTimeout, batches: int):
	timeout.batch_count = batches
	return

func rebatch_timeout_search(method: String, batches: int):
	for timeout in pending_timeouts:  # This is a little seedy...
		if timeout.method != method: continue
		timeout.batch_count = batches
		return
#endregion

func goto(loc: Vector2i):
	sprite.scale = Vector2(SIZE/4, SIZE/4)  # Quarter length compensates for 4x resolution
	sprite.position = Vector2(loc.x + (width - 1)/2, loc.y + (height - 1)/2) * 16 * SIZE
	pass

func sayhi(times: int):
	for count in range(0, times):
		print('hi')

func onclick():
	print("Onclick not implemented")
