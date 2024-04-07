extends GridResource
class_name TownResources

var textures = {
	#"Flag": preload("res://Assets/flag.png"),
	"BldgFlag1": load("res://Assets/BldgFlag1L.png")
}

var subclasses = {
	"default": TownCell,
	#"Flag" : Flag,
	"BldgFlag1": BldgFlag1
}
