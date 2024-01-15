extends Camera2D


func _ready():
	zoom = Vector2(0.6, 0.6)


func _unhandled_input(event):
	if event is InputEventScreenDrag:
		if not position.x - event.relative.x * 2 < 0 and not position.x - event.relative.x * 2 > 4000:
			position.x -= event.relative.x * 2
		if not position.y - event.relative.y * 2 < 0 and not position.y - event.relative.y * 2 > 3000:
			position.y -= event.relative.y * 2
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and not zoom + Vector2(0.07, 0.07) > Vector2(1.2, 1.2):
		zoom += Vector2(0.07, 0.07)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and not zoom - Vector2(0.07, 0.07) < Vector2(0.4, 0.4):
		zoom -= Vector2(0.07, 0.07)
	else:
		return
