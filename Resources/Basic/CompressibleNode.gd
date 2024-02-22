extends Node
class_name CompressibleNode

func compress() -> Dictionary:
	push_warning("Compress not implemented, using default")
	var dict = {}
	for property in get_script().get_script_property_list():
		dict[property.name] = property.value
	return dict

func decompress(dict: Dictionary):
	push_warning("Decompress not implemented, using default")
	for key in dict.keys():
		self["key"] = dict[key]
