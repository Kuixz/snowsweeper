extends CompressibleNode

@export var state: GameState
@export var stylus: Stylus 
@onready var grid: Grid = $Grid
@onready var koloktos: Koloktos = $Koloktos
@onready var camera: Camera2D = $Camera2D
@onready var ui: UILayer = $UILayer

const new_game = {
	"global": {
		"lives": 3,
		"score": 0,
		"flags": 25
	}
}
#var file_start_time: int = 0
#var lives: int = 0
#var score: int = 0
#var flags: int = 0

#region Compression
func compress() -> Dictionary:
	return {
		#"time": Time.get_unix_time_from_system(),
		#"file_start_time": file_start_time,
		"global": state.compress(),
		"grid": grid.compress(),
		"koloktos": koloktos.compress()
	}

func decompress(dict: Dictionary):
	#file_start_time = dict["file_start_time"]
	if dict.has("global"): state.decompress(dict["global"])
	if dict.has("grid"): grid.decompress(dict["grid"])
	
	if dict.has("koloktos"):
		var while_offline = koloktos.decompress(dict["koloktos"])
		for item in while_offline:
			#print(item[1])
			var callable = Callable(self, item[1])
			callable.call()

func save():
	stylus.save(compress())

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print('Final save')
		save()
		get_tree().quit()

func _ready():
	set_process(false)  # Maybe unnecessary?
	
	var data = stylus.load()
	if not data: data = new_game
	decompress(data)
	
	state.set_ui(ui)
	
	#print(get_script().get_script_property_list())
	#koloktos.set_timeout("say_hi", 2)
	#koloktos.set_timeout("add_life", 5)

#endregion

func _input(event):
	if event is InputEventMouseButton and event.pressed:
#		print(event)
		var loc = grid.screen_to_cell(event.position, camera.position)
		
		# Maybe fixed the inappropriate coupling - heart bank what do?
		if event.is_action_pressed("left_click"):
			grid.handle_left_click(loc)
		
		# Maybe fixed the inappropriate coupling.
		elif event.is_action_pressed('right_click'):
			grid.handle_right_click(loc)
		
		return
	if event.is_action_pressed('save'):
		stylus.save(compress())
		print('Saved!')

func add_life():
	state.lives += 1
	#ui.add_life()

func _on_grid_update(what: Grid.Update):
	match what:
		Grid.Update.EXPLODE:
			state.lives -= 1
			koloktos.set_timeout("add_life", 21600)  # 6 hours
		Grid.Update.OPEN:
			state.score += 100
		Grid.Update.FLAG:
			state.flags -= 1
		Grid.Update.UNFLAG:
			state.flags += 1
	#pass # Replace with function body.
