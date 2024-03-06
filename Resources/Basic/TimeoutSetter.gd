extends CompressibleNode
class_name TimeoutSetter

# Called when the node enters the scene tree for the first time.
var pending_timeouts = []

#region Timeouts
func decompress_timeouts(arr: Array):
	for data in arr:
		var timeout = BatchTimeout.decompress(self, data)
		var elapsed = timeout.on_deserialize_rebatch(Chronos.current_time)
		timeout.callback(elapsed)
		print(timeout.compress())
		if timeout.batch_count > 0:
			push_timeout(timeout)

func callback(timeout: BatchTimeout, cycles: int):
	var callable = Callable(self, timeout.method)
	callable.call(cycles)
	if timeout.batch_count == 0:
		pending_timeouts.erase(timeout)

func push_timeout(timeout: BatchTimeout):
	Chronos.push_timeout(timeout)
	pending_timeouts.push_back(timeout)
	#Chronos.attach(self)
	#print(pending_timeouts)
	
func set_timeout(method: String, seconds: float, batch_count: int = 1, category = "none"):
	var timeout = BatchTimeout.new(self, batch_count, seconds, Chronos.time() + seconds, method)
	push_timeout(timeout)
	
func rebatch_timeout(timeout: BatchTimeout, batches: int):
	if batches != 0: timeout.batch_count = batches
	else: pending_timeouts.erase(timeout); Chronos.cancel_timeout(timeout)

func rebatch_timeout_search(method: String, batches: int):
	for timeout in pending_timeouts:  # This is a little seedy...
		if timeout.method != method: continue
		timeout.batch_count = batches
		return
#endregion

func sayhi(times: int):
	for count in range(0, times):
		print('hi')



