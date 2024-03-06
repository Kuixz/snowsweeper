extends CanvasLayer
class_name UILayer

var hearts = []

#func init(state: GameState):
	#update_lives(state.lives)
	#update_flags(state.flags)
	#update_score(state.score)
func init():
	Global.set_ui(self)
	update_lives(Global.lives)
	update_flags(Global.flags)
	update_score(Global.score)

func update_flags(num: int):
	$TopLeft/FlagCount.text = "x" + str(num)

func update_lives(num: int):
	var diff = num - len(hearts)
	for count in range(0, diff):
		_add_life()
	
	for count in range(diff, 0):
		_remove_life()

func _add_life():
	var heart: TextureRect = $TopLeft/Heart.duplicate()
	heart.visible = true
	$TopLeft.add_child(heart)
	hearts.push_back(heart)
func _remove_life():
	hearts.pop_back().queue_free()

func update_score(num: int):
	$Points.text = str(num)

## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
