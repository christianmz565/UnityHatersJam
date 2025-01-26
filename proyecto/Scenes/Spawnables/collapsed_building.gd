extends Spawnable
class_name CollapsedBuilding

static var pre := preload("res://Scenes/Spawnables/CollapsedBuilding.tscn");
var initial_pos: Vector2;
@export var speed: float;
var velocity: Vector2;
var dir: Vector2;
var falling := false;

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioPlayer = $AudioPlayer

# collapsed building only takes the x position, the y position is the ceiling
static func _spawn(pos: Vector2):
	var instance = pre.instantiate() as CollapsedBuilding;
	instance.initial_pos = pos;
	return instance;

static func get_spawn_pos():
	var viewport_size = Map.Instance._get_viewport_size();
	var n_x = viewport_size.x / 2 + OFFSET;
	var n_y = -(viewport_size.y / 2);
	return Vector2(n_x, n_y);

func _physics_process(delta: float) -> void:
	if falling:
		position += velocity * delta;
	

func _ready() -> void:
	global_position = initial_pos;

	var valid_dir = Vector2.DOWN;
	dir = valid_dir;
	velocity = valid_dir * speed;

	audio.play()
	_post_spawn();

func _on_detect_area_body_entered(body: Node2D) -> void:
	if (body is Player):
		falling = true;
		sprite.play("falling");
		audio.play()
		
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
