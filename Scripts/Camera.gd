extends Camera2D

@export var camera_sensitivity = 20;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
func _input(event):
	if event is InputEventPanGesture:
		position.x += event.delta.x * camera_sensitivity;
		position.y += event.delta.y * camera_sensitivity;
