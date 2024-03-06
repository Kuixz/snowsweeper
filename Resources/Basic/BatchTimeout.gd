extends Object
class_name BatchTimeout

var parent
#var id: int
var batch_count: int = 1
var duration: float;
var target_time: float;
var method: String

#region Compression
func compress() -> Dictionary:
	return {
		#"id": id,
		"batch_count": batch_count,
		"duration": duration,
		"target_time": target_time,
		"method": method
	}
 
static func decompress(script, dict: Dictionary) -> BatchTimeout:
	return BatchTimeout.new(script, dict["batch_count"],dict["duration"],dict["target_time"],dict["method"])
#endregion

func _init(script, b:int, d: float, t: float, m: String):
	parent = script
	#id = i
	batch_count = b
	duration = d
	target_time = t
	method = m

func advance():
	#if batch_count == 1: return true
	target_time += duration
	batch_count -= 1
	#return false

func on_deserialize_rebatch(time: float) -> int:
	var elapsed_cycles = 0
	while (elapsed_cycles < batch_count and target_time + ((elapsed_cycles + 1) * duration) < time): elapsed_cycles += 1
	batch_count -= elapsed_cycles
	target_time += elapsed_cycles * duration
	return elapsed_cycles

func callback(cycles: int):
	parent.callback(self, cycles)
	#var callable = Callable(parent, method)
	#callable.call(cycles)
