extends CanvasLayer
#class_name UILayer

var hearts = []

func set_flags(num: int):
	$TopLeft/FlagCount.text = "x" + str(num)

func add_life():
	var heart: TextureRect = $TopLeft/Heart.duplicate()
	heart.visible = true
	$TopLeft.add_child(heart)
	hearts.push_back(heart)

func remove_life():
	hearts.pop_back().queue_free()

func change_lives(num: int):
	for count in range(0, num):
		add_life()
	
	for count in range(num, 0):
		remove_life()

## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
