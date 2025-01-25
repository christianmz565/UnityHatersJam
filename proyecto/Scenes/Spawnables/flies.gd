extends Spawnable
class_name Flies

static var pre := preload("res://Scenes/Spawnables/Flies.tscn");
var initial_pos: Vector2;
@export var speed: float;
var velocity: Vector2;
var dir: Vector2;

static func _spawn(pos: Vector2):
	var instance = pre.instantiate() as Flies;
	instance.initial_pos = pos;
	return instance;

func _physics_process(delta: float) -> void:
	if (not TestShip.Instance):
		return;
	dir = global_position.direction_to(TestShip.Instance.global_position);
	velocity = dir * speed;
	position += velocity * delta;

func _ready() -> void:
	position = initial_pos;

	_post_spawn();
