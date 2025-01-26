extends Area2D
class_name Bullet

@export var speed: float = 800;
@export var damage: float = 34.0;

func _process(delta: float) -> void:
	position += transform.x * speed * delta;

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free();
