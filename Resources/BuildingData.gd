extends Resource
class_name BuildingData

var dimensions = {
	"BldgFlag1": Vector2i(3,3)
}

var costs = {
	"BldgFlag1": {
		Inventory.MATERIALS.STONE: 8
		#Inventory.MATERIALS.ANN_CLUSTER: 1
	}
}



func get_dimensions(subclass: String) -> Vector2i:
	return dimensions[subclass]

func get_cost(recipe: String) -> Dictionary:
	return costs[recipe]
