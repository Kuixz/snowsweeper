extends TownCell
class_name BldgFlag1

#var subclass = "BldgFlag1"

# TODO TODO TODO TODO TODO. Switch AWAY from this goofy ahh inheritance bs,
# and into a standardized format.

const duration: int = 300
const capacity: int = 12  # 24
var holding: int = 0

#region Compression
func _ready(): #  init():  #_ready():
	#width = 3
	#height = 3
	subclass = "BldgFlag1"
	super._ready()
	#sprite.texture = res.textures[subclass]
	#subclass = "BldgFlag1"

func compress() -> Dictionary:
	var dict = super.compress()
	dict["holding"] = holding
	return dict

func decompress(dict: Dictionary):
	if dict.has("holding"): holding += dict["holding"]  # erase me  # why?
	super.decompress(dict)
#endregion

func init():
	set_timeout("create_flag", duration, capacity) # 300, capacity)

func create_flag(times: int):
	holding += times
	print("Created flag(s). Now holding %s" % str(holding))

func on_click():
	if holding == 0:
		print("Get info about BldgFlag1")
		return
	Global.flags += holding
	print("Claimed %s flags" % str(holding))
	holding = 0
	if len(pending_timeouts) > 0:
		# Seedy?
		rebatch_timeout(pending_timeouts[0], capacity)
	else:
		set_timeout("create_flag", duration, capacity)  # 300, capacity)
		#print(Chronos.timeouts_queue._data)
	#get_parent().emit_signal("update", Grid.Update.UNFLAG)
