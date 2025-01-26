extends Spawnable
class_name SpiderWeb

static var pre := preload("res://Scenes/Spawnables/SpiderWeb.tscn");
var initial_pos: Vector2;
@export var speed: float;
@export var health: float = 250;
var velocity: Vector2;
var dir: Vector2;

# spider web spawns on position
static func _spawn(pos: Vector2):
	var instance = pre.instantiate() as SpiderWeb;
	instance.initial_pos = pos;
	return instance;

func _ready() -> void:
	position = initial_pos;
	var valid_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized();
	dir = valid_dir;
	velocity = valid_dir * speed;
	$AudioPlayer.play()
	_post_spawn();

func _physics_process(delta: float) -> void:
	position += velocity * delta;

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func take_damage(damage: float) -> void:
	health -= damage;
	if health <= 0:
		queue_free();
