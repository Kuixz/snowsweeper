extends Node

var current_time = time()
var timeouts_queue: PriorityQueue = PriorityQueue.new()
var global_timeout_id = -1
var observers = []  # {}  # Make sure that Timekeeper.decompress() comes AFTER Grid.decompress() for registration of listeners
#var tickets = []

#region Compression
func _ready():
	set_process(false)
#endregion
	
func time():
	return Time.get_unix_time_from_system()

func push_timeout(timeout: BatchTimeout):
	#var index = timeouts_queue.bsearch_custom(timeout, func(entry1, entry2): return entry1.target_time < entry2.target_time)
	timeouts_queue.insert(timeout, timeout.target_time)  # TODO make a specialized queue, or consider a splay tree
	set_process(true)  # NOTE Hopefully not expensive when spurious
	#print(timeout.method)

func cancel_timeout(timeout: BatchTimeout):
	timeouts_queue.erase(timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Getting unix time feels very wrong, but is robust against Engine.timescale and any delta drift.
	current_time = time()
	var head = timeouts_queue.head() 
	if head[0] < current_time:
	#if (head && head[0] < current_time):
		var out_head = timeouts_queue.extract()
		out_head.advance()
		out_head.callback(1); # print("Process call")
		if out_head.batch_count > 0:
			push_timeout(out_head) 
		if timeouts_queue.size() == 0:
			set_process(false)
