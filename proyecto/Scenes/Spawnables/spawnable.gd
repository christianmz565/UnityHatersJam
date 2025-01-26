extends Node2D
class_name Spawnable

const OFFSET = 50;

# TODO: _spawn only returns the instance, it should be added as a child of the map generator scene from there
static func _spawn(pos: Vector2):
	pass

# This is the generic behavior for all spawnables
func _post_spawn():
	$Area2D.connect("body_entered", _on_body_entered);
	$Area2D.connect("area_entered", _on_area_entered);

func _on_body_entered(body: Node2D):
	if (body is Player):
		body.destroy();
	
func take_damage(damage: float) -> void:
	pass
	
static func get_spawn_pos():
	pass

func _on_area_entered(area: Area2D):
	if area is Bullet:
		print("hit")
		take_damage(area.damage);
		area.queue_free();
