extends BatchTimeoutSetter
#extends TimeoutSetter

#@export var state: GameState
@export var stylus: Stylus 
@onready var grid: Grid = $Grid
#@onready var koloktos: Koloktos = $Koloktos
#@onready var camera: Camera2D = $Camera2D
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
	var dict = {
		#"time": Time.get_unix_time_from_system(),
		#"file_start_time": file_start_time,
		"global": Global.compress(),
		"inventory": Inventory.compress(),
		"grid": grid.compress(),
		#"chronos": Chronos.compress(),
		"timeouts": pending_timeouts
	}
	if len(pending_timeouts) > 0: dict["timeouts"] = pending_timeouts.map(func(x):return x.compress())
	return dict

func decompress(dict: Dictionary):
	#file_start_time = dict["file_start_time"]
	if dict.has("global"): Global.decompress(dict["global"])
	if dict.has("inventory"): Inventory.decompress(dict["inventory"])
	if dict.has("grid"): grid.decompress(dict["grid"])
	if dict.has("timeouts"): decompress_timeouts(dict["timeouts"])  # TODO

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
	
	ui.init()
#endregion

func _input(event):
	if event is InputEventPanGesture:
		Camera.scroll(event.delta)
		grid.handle_mouse_motion(Camera.get_mouse_position())
	if event is InputEventMouseButton and event.pressed:
		var raw_loc = event.position
		# Maybe fixed the inappropriate coupling - heart bank what do?
		if event.is_action_pressed("left_click"):
			#grid.handle_left_click(loc)
			grid.handle_left_click(raw_loc)
		
		# Maybe fixed the inappropriate coupling.
		elif event.is_action_pressed('right_click'):
			#grid.handle_right_click(loc)
			grid.handle_right_click(raw_loc)
		
		return
	if event is InputEventMouseMotion:
		var raw_loc = event.global_position
		if not Camera.in_frame(raw_loc): return  # prevent mouse motion function calls when mouse is out of frame
		#var loc = grid.screen_to_cell(event.position, camera.position)
		grid.handle_mouse_motion(raw_loc)
		return
	if event.is_action_pressed('save'):
		stylus.save(compress())
		print('Saved!')
	
	if event.is_action_pressed('test'):
		print('test')
		grid.build_preview.toggle_build_preview()
		pass

func add_life(lives: int):
	Global.lives += lives
	#ui.add_life()

func _on_grid_update(what: Grid.Update):
	match what:
		Grid.Update.EXPLODE:
			Global.lives -= 1
			#koloktos.set_timeout("add_life", 21600)  # 6 hours
			set_timeout("add_life", 21600, 1)
		Grid.Update.OPEN:
			Global.score += 100
		Grid.Update.FLAG:
			Global.flags -= 1
		Grid.Update.UNFLAG:
			Global.flags += 1
	#pass # Replace with function body.
