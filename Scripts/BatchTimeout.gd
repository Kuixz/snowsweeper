extends Node
class_name BatchTimeout

static var child_scene = preload("res://Scenes/progress_circle.tscn")

var parent: BatchTimeoutSetter
var child: ProgressCircle

var sum_delta: float = 0.0

var batch_count: int = 1
var duration: float = 5;
#var target_time: float;
var method: String;

#region Compression
func compress() -> Dictionary:
	return {
		#"id": id,
		"sum_delta": sum_delta,
		"batch_count": batch_count,
		"duration": duration,
		"method": method
	}
 
static func decompress(script, dict: Dictionary) -> BatchTimeout:
	return BatchTimeout.new(script, dict["batch_count"], dict["duration"],dict["method"], dict["sum_delta"])
#endregion

func _init(script: BatchTimeoutSetter, b:int, d: float, m: String, sd: float = 0.0):
	parent = script
	#id = i
	batch_count = b
	duration = d
	#target_time = t
	method = m
	sum_delta = sd
	#set_process(true)
	child = child_scene.instantiate()
	#child.value = sd
	child.position = parent.position
	child.max_value = duration
	add_child(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sum_delta += delta
	#print('ud')
	if sum_delta >= duration:
		print('called')
		callback(1)
		batch_count -= 1
		sum_delta -= duration
		if batch_count <= 0:
			#queue_free()
			parent.erase_timeout(self)  # TODO change this
	child.value = sum_delta

func on_deserialize_rebatch(elapsed_time: float): #  -> bool:
	var elapsed_cycle_time: float = 0.0
	var elapsed_cycles: int = 0
	while (elapsed_cycles < batch_count and sum_delta + elapsed_cycle_time + duration <= elapsed_time): 
		elapsed_cycles += 1
		elapsed_cycle_time += duration
	batch_count -= elapsed_cycles
	#sum_delta = sum_delta + elapsed_time - elapsed_cycles * duration
	sum_delta += elapsed_time - elapsed_cycle_time
	if elapsed_cycles > 0:
		callback(elapsed_cycles)
	#if batch_count == 0:
		##return false
		##parent.erase_timeout(self)
		#return false
	#return true
	#child.value = sum_delta
	
	return batch_count > 0

func callback(cycles: int):
	parent.callback(method, cycles)
