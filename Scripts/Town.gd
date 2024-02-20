extends Node

@export var stylus: Stylus 
@onready var grid: Grid = $Grid
@onready var koloktos = $Koloktos
@onready var camera: Camera2D = $Camera2D
@onready var ui = $UILayer

#var file_start_time: int = 0
var lives: int = 0
var flags: int = 0

#region Compression
func compress() -> Dictionary:
	return {
		#"time": Time.get_unix_time_from_system(),
		#"file_start_time": file_start_time,
		"lives": lives,
		"flags": flags,
		"grid": grid.compress(),
		"koloktos": koloktos.compress()
	}

func decompress(dict: Dictionary):
	#file_start_time = dict["file_start_time"]
	lives = dict["lives"]
	flags = dict["flags"]
	grid.decompress(dict["grid"])
	ui.change_lives(lives)
	ui.set_flags(flags)
	
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
	decompress(data)
	
	#koloktos.set_timeout("say_hi", 2)
	#koloktos.set_timeout("add_life", 5)
	#if data: decompress(data)
	#else:
		#file_start_time = Time.get_unix_time_from_system()
		#$UILayer.change_lives(3)
		#$UILayer.set_flags(25)

#endregion

func _input(event):
	if event is InputEventMouseButton and event.pressed:
#		print(event)
		var loc = grid.screen_to_cell(event.position, camera.position)
		
		# Again, inappropriate coupling - heart bank what do?
		if event.is_action_pressed("left_click"):
			if (lives == 0): return
			var did_explode = grid.reveal_at(loc)
			if (did_explode):
				lives -= 1
				ui.change_lives(-1)
				koloktos.set_timeout("add_life", 86400)
		
		# This solution is bad because of inappropriate coupling.
		elif event.is_action_pressed('right_click'):
			if not grid.cell_exists(loc): return
			flags -= grid.handle_right_click(loc, flags)
			ui.set_flags(flags)
		return
	if event.is_action_pressed('save'):
		stylus.save(compress())
		print('Saved!')

func add_life():
	lives += 1
	ui.add_life()

# TODO Flags will be collected from buildings, not auto-regen.
#func flag_regen():
	#flags += 1
	#ui.set_flags(flags)
	#if (flags < 25):
		#koloktos.set_timeout("flag_regen", 600)

#func say_hi():
	#print('hi')

#func _on_grid_explosion():
#	lives -= 1
#	print('Boom! Lives remaining: %s' % lives)
