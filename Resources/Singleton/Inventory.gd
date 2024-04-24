extends CompressibleNode

enum MATERIALS {
	STONE,
	IRON,
	SILICON,
	SILVER,
	HEARTHSTONE,
	BLAZESTONE,
	PRISMIUM,
	ANN_CLUSTER,
	
	BRICK,
	FURNACE,
	PIPE,
	SNOWCATCHER,
	PLATE,
	GLASS,
	LIGHT,
	CIRCUIT,
	SUNCATCHER,
	POWER_FLAG,
	BEACON_FLAG,
	TRANSFUSION,
	FLYWHEEL,
	DRILL
}

#enum BUILDINGS {
	#BLDGFLAG1
#}

var numbered_materials = [
	null,
	MATERIALS.STONE,
	MATERIALS.IRON,
	MATERIALS.SILICON,
	MATERIALS.SILVER,
	MATERIALS.HEARTHSTONE,
	MATERIALS.BLAZESTONE,
	MATERIALS.PRISMIUM,
	MATERIALS.ANN_CLUSTER
]

var counts: Dictionary = {}
#@export var building_data: BuildingData
#var counts = [0, 0, 0, 0, 0, 0, 0, 0]

#region Compression
func compress() -> Dictionary:
	var dict = {
		"counts": counts
	}
	return dict

func decompress(dict: Dictionary):
	if dict.has("counts"): 
		#counts = dict["counts"]
		var dict_counts = dict["counts"]
		for key in dict_counts:
			counts[int(key)] = dict_counts[key]
		#for index in range(0, len(dict_counts)):
			#counts[index] = dict_counts[index]
	print(counts)
#endregion

func get_or_else(dict: Dictionary, key, default):
	if dict.has(key): return dict[key]
	else: return default



func add_material(material: MATERIALS, count: int):
#func add_material(material: int, count: int):
	counts[material] = get_or_else(counts, material, 0) + count
	#counts[material - 1] += count
	print(counts)

func harvest(number: int, count: int = 1):
	add_material(numbered_materials[number], count)



func count_of(material: MATERIALS) -> int:
#func count_of(material: int) -> int:
	if counts.has(material): return counts[material]
	else: return 0
	#return counts[material - 1]

func has_at_least(material: MATERIALS, count: int) -> bool:
#func has_at_least(material: int, count: int) -> bool:
	return count_of(material) >= count

func can_afford(recipe: Dictionary, auto_debit = false) -> bool:
	#var costs = building_data.get_cost(recipe)
	for key in recipe:
		if not has_at_least(key, recipe[key]):
			return false
	if auto_debit: debit(recipe)
	return true

func debit(recipe: Dictionary):
	for key in recipe:
		add_material(key, -recipe[key])
