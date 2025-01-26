extends Spawnable
class_name Serpent

static var pre := preload("res://Scenes/Spawnables/Serpent.tscn");
var initial_pos: Vector2;
@export var speed: float;
@export var attack_time: float;
@export var health: float = 100.0;
var velocity: Vector2;
var dir: Vector2;
var attacking := false;

# serpent only takes the x position, the y position is chosen from outside the screen
static func _spawn(pos: Vector2):
	var instance = pre.instantiate() as Serpent;
	instance.initial_pos = pos;
	return instance;
	
static func get_spawn_pos():
	var viewport_size = Map.Instance._get_viewport_size();
	var view_y_half = viewport_size.y / 2;
	var n_x = randi_range(-view_y_half, view_y_half);
	var n_y = ((viewport_size.y / 2) + OFFSET) * Globals.get_rand_pos_neg();
	return Vector2(n_x, n_y);

func _physics_process(delta: float) -> void:
	if attacking:
		position += velocity * delta;

func _ready() -> void:
	var window_height = Map.Instance._get_viewport_size().y;
	global_position = initial_pos;

	var angle = global_position.angle_to_point(Player.Instance.global_position) + randf_range(-PI / 8, PI / 8);
	var valid_angle = angle - PI / 2;
	var valid_dir = Vector2(cos(angle), sin(angle));
	rotation = valid_angle;
	dir = valid_dir;
	velocity = valid_dir * speed;

	$WarningSprite.scale.y = window_height * 1.3;

	prepare_attack();
	$AudioPlayer.play()
	_post_spawn();

func prepare_attack():
	$AttackTimer.start(attack_time);

func _on_attack_timer_timeout() -> void:
	attacking = true;
	$WarningSprite.visible = false;


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free();
	
func take_damage(damage: float) -> void:
	health -= damage;
	if health <= 0:
		queue_free();
