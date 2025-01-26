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
	
static func get_spawn_pos():
	var viewport_size = Map.Instance._get_viewport_size();
	var view_y_half = viewport_size.y / 2;
	var n_x = viewport_size.x / 2 + viewport_size.x / 2 + randi_range(OFFSET, viewport_size.x);
	var n_y = randi_range(-view_y_half, view_y_half);
	return Vector2(n_x, n_y);

func _ready() -> void:
	global_position = initial_pos;
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
		Globals.current_score += 100;
