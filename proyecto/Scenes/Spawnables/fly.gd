extends Spawnable
class_name Fly

@export var health: float = 60;

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

static func get_spawn_pos():
	var viewport_size = Map.Instance._get_viewport_size();
	var n_x: float;
	var n_y: float;
	if (randf() >= 0.5):
		var view_y_half = viewport_size.y / 2;
		n_x = ((viewport_size.x / 2) + OFFSET) * Globals.get_rand_pos_neg();
		n_y = randi_range(-view_y_half, view_y_half);
	else:
		var view_x_half = viewport_size.x / 2;
		n_x = randi_range(-view_x_half, view_x_half);
		n_y = ((viewport_size.y / 2) + OFFSET) * Globals.get_rand_pos_neg();
		
	return Vector2(n_x, n_y);

func _process(_delta: float) -> void:
	$Sprite.flip_h = global_position.x < Player.Instance.global_position.x;
	

func _physics_process(delta: float) -> void:
	dir = global_position.direction_to(Player.Instance.global_position);
	velocity = dir * speed;
	position += velocity * delta;

func _ready() -> void:
	global_position = initial_pos;
	_post_spawn();

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func take_damage(damage: float) -> void:
	health -= damage;
	if health <= 0:
		queue_free();
