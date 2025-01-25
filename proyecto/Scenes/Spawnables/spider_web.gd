extends Spawnable
class_name SpiderWeb

static var pre := preload("res://Scenes/Spawnables/SpiderWeb.tscn");
var initial_pos: Vector2;
@export var speed: float;
var velocity: Vector2;
var dir: Vector2;

# spider web spawns on position and returns the instance
static func _spawn(pos: Vector2):
	var instance = pre.instantiate() as SpiderWeb;
	instance.initial_pos = pos;
	return instance;

func _ready() -> void:
	position = initial_pos;
	var valid_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized();
	dir = valid_dir;
	velocity = valid_dir * speed;
	
	_post_spawn();

func _physics_process(delta: float) -> void:
	position += velocity * delta;
