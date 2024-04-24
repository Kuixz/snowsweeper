extends CompressibleNode
class_name BatchTimeoutSetter

var pending_timeouts = []

#func decompress(dict: Dictionary):
	#push_warning("Decompress not implemented, using default")
	#for key in dict.keys():
		#if key == "pending_timeouts":
			#decompress_timeouts(dict["pending_timeouts"])
		#else: self[key] = dict[key]

#region Timeouts
func decompress_timeouts(arr: Array):
	var elapsed = Global.elapsed
	for data in arr:
		var timeout = BatchTimeout.decompress(self, data)
		#add_child(timeout)
		if timeout.on_deserialize_rebatch(elapsed):
			push_timeout(timeout)
		#if 
			#add_child(timeout)
		#timeout.callback(elapsed)
		#print(timeout.compress())
		#if timeout.batch_count > 0:
			#push_timeout(timeout)

func callback(method: String, cycles: int):
	var callable = Callable(self, method)
	callable.call(cycles)
	#if timeout.batch_count == 0:
		#pending_timeouts.erase(timeout)

func erase_timeout(timeout: BatchTimeout):
	pending_timeouts.erase(timeout)
	timeout.queue_free()

func push_timeout(timeout: BatchTimeout):
	#Chronos.push_timeout(timeout)
	pending_timeouts.push_back(timeout)
	add_child(timeout)
	#Chronos.attach(self)
	#print(pending_timeouts)
	#pass
	
func set_timeout(method: String, seconds: float, batch_count: int = 1, category = "none"):
	if seconds == 0:
		callback(method, batch_count)
		return
	else:
		var timeout = BatchTimeout.new(self, batch_count, seconds, method)
		# add_child(timeout)
		# push_timeout(timeout)
		push_timeout(timeout)  # NOTE: Insecure, easy to save edit
	
func rebatch_timeout(timeout: BatchTimeout, batches: int):
	#if batches != 0: timeout.batch_count = batches
	#timeout.batch_count = batches
	if batches == 0: erase_timeout(timeout)
	else: timeout.batch_count = batches
	#else: pending_timeouts.erase(timeout); Chronos.cancel_timeout(timeout)

func timeout_of_method(method: String) -> BatchTimeout: 
	#for timeout in get_children():
	for timeout in pending_timeouts:
		#if not timeout is BatchTimer: continue
		if timeout.method != method: continue
		return timeout
	return null

func has_timeout_of_method(method: String) -> bool:
	return (timeout_of_method(method) != null)

func rebatch_timeout_search(method: String, batches: int) -> bool:  # Unused.
	var timeout = timeout_of_method(method)
	if (timeout == null): return false
	rebatch_timeout(timeout, batches)
	return true
	#for timeout in pending_timeouts:  # This is a little seedy...
		#if timeout.method != method: continue
		#timeout.batch_count = batches
		#return
#endregion

#func sayhi(times: int):
	#for count in range(0, times):
		#print('hi')



#func show_timeout()
