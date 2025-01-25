extends Node2D
class_name Spawnable


# TODO: _spawn only returns the instance, it should be added as a child of the map generator scene from there
static func _spawn(pos: Vector2):
	pass

func _post_spawn():
	$Area2D.connect("body_entered", _on_body_entered);

func _on_body_entered(body: Node2D):
	if (body is TestShip):
		body.destroy();
