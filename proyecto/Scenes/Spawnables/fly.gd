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

func _process(_delta: float) -> void:
	$Sprite.flip_h = global_position.x < Player.Instance.global_position.x;

func _physics_process(delta: float) -> void:
	dir = global_position.direction_to(Player.Instance.global_position);
	velocity = dir * speed;
	position += velocity * delta;

func _ready() -> void:
	position = initial_pos;
	_post_spawn();

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func take_damage(damage: float) -> void:
	health -= damage;
	if health <= 0:
		queue_free();
