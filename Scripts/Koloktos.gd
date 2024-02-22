extends Node  # CompressibleNode, when I start storing file start time. TODO
class_name Koloktos

var current_time = time()
var timeouts_queue: PriorityQueue = PriorityQueue.new()

#region Compression
func compress() -> Array:
	return timeouts_queue._data

# TODO: This is very efficient, but completely falls apart if wait times change
# a la efficiency boosts like the Salve Station.

func decompress(arr: Array) -> Array:
	var i = 0; var n = arr.size()
	while (i < n && arr[i][0] < current_time): i += 1
	if i == n: return arr
	timeouts_queue.override_data(arr.slice(i, n))
	set_process(true)
	return arr.slice(0, i)

func _ready():
	set_process(false)
#endregion
	
func time():
	return Time.get_unix_time_from_system()

func set_timeout(method: String, seconds: float):
	# if (not f.is_valid()): push_error("Invalid timeout: method is not valid"); return
	timeouts_queue.insert(method, time() + seconds)
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Getting unix time feels very wrong, but is robust against Engine.timescale and any delta drift.
	current_time = time()
	var head = timeouts_queue.head()
	if (head && head[0] < current_time):
		# Very dangerous! TODO
		var callable = Callable(get_parent(), timeouts_queue.extract())
		callable.call()
		if timeouts_queue.empty():
			set_process(false)
