extends Camera2D

@export var camera_sensitivity = 20;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func scroll(delta: Vector2):
	position += delta * camera_sensitivity

#func _input(event):
	#if event is InputEventPanGesture:
		#position.x += event.delta.x * camera_sensitivity;
		#position.y += event.delta.y * camera_sensitivity;

func in_frame(loc: Vector2) -> bool:
	return get_viewport().get_visible_rect().has_point(loc)
	#return false

func get_mouse_position() -> Vector2:
	return get_viewport().get_mouse_position()

func screen_to_world(loc: Vector2) -> Vector2:
	var rect = get_viewport().get_visible_rect()
	#var worldX = loc.x - rect.size.x / 2 + position.x
	#var worldY = loc.y - rect.size.y / 2 + position.y
	#return Vector2(worldX, worldY)
	return loc - (0.5) * (rect.size) + position
