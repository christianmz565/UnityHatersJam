extends Node
class_name GameInput

static func process_input() -> Vector2:
	var direction: Vector2 = Vector2.ZERO;
	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	direction = direction.normalized()
	
	return direction
