extends Spawnable
class_name Serpent

static var pre := preload("res://Scenes/Spawnables/Serpent.tscn");
var initial_pos: Vector2;
@export var speed: float;
@export var attack_time: float;
var velocity: Vector2;
var dir: Vector2;
var attacking := false;

# serpent only takes the x position, the y position is chosen from outside the screen
static func _spawn(pos: Vector2):
	var instance = pre.instantiate() as Serpent;
	instance.initial_pos = pos;
	return instance;

func _physics_process(delta: float) -> void:
	if attacking:
		position += velocity * delta;

func _ready() -> void:
	var down = randi_range(0, 1) == 0;
	var window_height = get_viewport_rect().size.y;
	var y_pos = window_height / 2 * (1 if down else -1);
	var valid_pos = Vector2(initial_pos.x, y_pos);
	position = valid_pos;

	var angle = global_position.angle_to_point(TestShip.Instance.global_position) + randf_range(-PI / 8, PI / 8);
	var valid_angle = angle - PI / 2;
	var valid_dir = Vector2(cos(angle), sin(angle));
	rotation = valid_angle;
	dir = valid_dir;
	velocity = valid_dir * speed;

	$WarningSprite.scale.y = window_height * 1.3;

	prepare_attack();
	_post_spawn();

func prepare_attack():
	$AttackTimer.start(attack_time);

func _on_attack_timer_timeout() -> void:
	attacking = true;
	$WarningSprite.visible = false;
