extends Node2D

@onready var camera: Camera2D = $Camera2D;
@onready var player: CharacterBody2D = $Player;

@export var enemy_types: Dictionary = {
	# "Fly": Fly,
	# "Serpent": Serpent,
	"CollapsedBuilding": CollapsedBuilding,
	# "SpiderWeb": SpiderWeb
}

@export var camera_speed: float = 100.0;
@export var max_enemies_per_spawn: int = 4;
@export var spawn_distance: float = 500.0;

var spawn_intervals = {
	# "SpiderWeb": {"min": 4.0, "max": 8.0},
	# "Serpent": {"min": 8.0, "max": 16.0},
	# "Fly": {"min": 2.0, "max": 6.0},
	"CollapsedBuilding": {"min": 2.0, "max": 4.0}
}

var enemies: Array[Spawnable] = [];
var spawn_positions: Array[Vector2] = [];

var collapsed_building_min_distance: float = 300.0

func _ready() -> void:
	for enemy_type in enemy_types.keys():
		var timer: Timer = Timer.new();
		timer.name = "Timer_" + enemy_type;
		timer.one_shot = true;
		timer.connect("timeout", _spawn_enemy.bind(enemy_type));
		add_child(timer);
		_set_random_spawn_timer(timer, spawn_intervals[enemy_type])

func _process(delta: float) -> void:
	if player:
		# Camera mid point
		var camera_mid_x = camera.global_position.x;
		
		if player.global_position.x > camera_mid_x:
			camera.global_position.x += camera_speed * delta;
			
func _spawn_enemy(enemy_type: String) -> void:
	var num_enemies: int = randi_range(1, max_enemies_per_spawn);
	for _i in range(num_enemies):
		var type = enemy_types[enemy_type];
		var spawn_x = camera.global_position.x + spawn_distance + randi_range(-100, 100);
		var spawn_y = randi_range(-100, 300);
		var spawn_position = Vector2(spawn_x, spawn_y);
		
		if _is_valid_spawn_position(spawn_position, enemy_type):
			var enemy_instance = type._spawn(spawn_position)
			add_child(enemy_instance)
			enemies.append(enemy_instance)
			spawn_positions.append(spawn_position)
			
	var timer = get_node("Timer_" + enemy_type)
	_set_random_spawn_timer(timer, spawn_intervals[enemy_type])

func _is_valid_spawn_position(spawn_position: Vector2, enemy_type: String) -> bool:
	var min_distance = collapsed_building_min_distance if enemy_type == "CollapsedBuilding" else 150;
	for existing_position in spawn_positions:
		if position.distance_to(existing_position) < min_distance:
			return false;
	return true;
	
func _set_random_spawn_timer(timer: Timer, interval: Dictionary) -> void:
	var min_time = interval.get("min", 0.5)
	var max_time = interval.get("max", 2.0)
	if min_time >= max_time:
		push_error("El intervalo de spawn no es válido para el temporizador: " + timer.name)
		return
		
	timer.wait_time = randf_range(min_time, max_time)
	timer.start()
