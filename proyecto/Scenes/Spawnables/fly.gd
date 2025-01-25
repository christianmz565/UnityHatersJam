extends Spawnable
class_name Fly

static var pre := preload("res://Scenes/Spawnables/Fly.tscn");
var initial_pos: Vector2;
@export var speed: float;
var velocity: Vector2;
var dir: Vector2;

# fly spawns on position
static func _spawn(pos: Vector2):
	var instance = pre.instantiate() as Fly;
	instance.initial_pos = pos;
	return instance;

func _process(_delta: float) -> void:
	$Sprite.flip_h = global_position.x < TestShip.Instance.global_position.x;

func _physics_process(delta: float) -> void:
	dir = global_position.direction_to(TestShip.Instance.global_position);
	velocity = dir * speed;
	position += velocity * delta;

func _ready() -> void:
	position = initial_pos;

	_post_spawn();
