extends GridResource
class_name MinefieldResources

var subclasses = {
	"default": MinefieldCell
}

var textures = {
	'default': preload('res://Assets/TileUnknown.png'),
	#'closed': preload('res://Assets/TileUnknown.png'),
	#'open': preload('res://Assets/TileEmpty.png'),
	'mine': preload('res://Assets/TileExploded.png'),
	'flag': preload('res://Assets/TileFlag.png'),
	'0': preload('res://Assets/TileEmpty.png'),
	'1': preload('res://Assets/Tile1.png'),
	'2': preload('res://Assets/Tile2.png'),
	'3': preload('res://Assets/Tile3.png'),
	'4': preload('res://Assets/Tile4.png'),
	'5': preload('res://Assets/Tile5.png'),
	'6': preload('res://Assets/Tile6.png'),
	'7': preload('res://Assets/Tile7.png'),
	'8': preload('res://Assets/Tile8.png'),
#	'9': preload('res://Assets/Tile9.png')
}

const harvest_durations = [
	0, 0, 30, 480, 1200, 7200, 43200, 259200
]

func get_harvest_duration(resource: int) -> int:
	return harvest_durations[resource - 1]
