extends Node2D
class_name Map

@onready var camera: Camera2D = $Camera2D;
@onready var player: CharacterBody2D = $Player;
@onready var rain: RainParticles = $RainParticles
@onready var boundaries: StaticBody2D = $StaticBody2D

@export var enemy_types: Dictionary = {
 	"Fly": Fly,
	"Serpent": Serpent,
	"CollapsedBuilding": CollapsedBuilding,
	"SpiderWeb": SpiderWeb
}

@export var camera_speed: float = 100.0;
@export var max_enemies_per_spawn: int = 4;
@export var spawn_distance: float = 500.0;

@export var random_event_interval: Dictionary = {"min": 50.0, "max": 60.0}
@export var random_event_duration: Dictionary = {"min": 9.0, "max": 12.0}

var spawn_data = {
	"SpiderWeb": {"min": 10.0, "max": 12.0, "am_min": 2, "am_max": 3},
	"Serpent": {"min": 8.0, "max": 16.0, "am_min": 3, "am_max": 5},
	"Fly": {"min": 4.0, "max": 6.0, "am_min": 2, "am_max": 3},
	"CollapsedBuilding": {"min": 10.0, "max": 20.0, "am_min": 1, "am_max": 1}
}

static var Instance: Map;
var enemies: Array[Spawnable] = [];
var spawn_positions: Array[Vector2] = [];

var collapsed_building_min_distance: float = 300.0

func _get_viewport_size():
	return get_viewport().size / $Camera2D.zoom.x;

var camera_active: bool = true

var event_timer: Timer = null
var event_duration_timer: Timer = null

func _ready() -> void:
	Instance = self;
	rain.stop_rain()
	
	for enemy_type in enemy_types.keys():
		var timer: Timer = Timer.new();
		timer.name = "Timer_" + enemy_type;
		timer.one_shot = true;
		timer.connect("timeout", _spawn_enemy.bind(enemy_type));
		add_child(timer);
		_set_random_spawn_timer(timer, spawn_data[enemy_type]);
		
	event_timer = Timer.new();
	event_timer.name = "Event Timer";
	event_timer.one_shot = true;
	event_timer.connect("timeout", _on_random_event_triggered);
	add_child(event_timer);
	_set_random_timer(event_timer, random_event_interval)
	
	event_duration_timer = Timer.new()
	event_duration_timer.name = "EventDurationTimer"
	event_duration_timer.one_shot = true
	event_duration_timer.connect("timeout", _on_event_finished)
	add_child(event_duration_timer)
	
	await get_tree().create_timer(1.0).timeout;
	$AudioPlayer.play()

func _process(delta: float) -> void:
	if camera_active and player:
		# Camera mid point
		var camera_mid_x = camera.global_position.x;
		
		if player.global_position.x > camera_mid_x:
			camera.global_position.x += camera_speed * delta;
			rain.global_position.x = camera.global_position.x;
			boundaries.global_position.x = camera.global_position.x;
			
func _spawn_enemy(enemy_type: String) -> void:
	var num_enemies := randi_range(spawn_data[enemy_type].am_min, spawn_data[enemy_type].am_max);
	for _i in range(num_enemies):
		var type = enemy_types[enemy_type];
		var spawn_pos = enemy_types[enemy_type].get_spawn_pos();
		var spawn_x = camera.global_position.x + spawn_pos.x;
		var spawn_y = camera.global_position.y + spawn_pos.y;
		var spawn_position = Vector2(spawn_x, spawn_y);
		
		if _is_valid_spawn_position(spawn_position, enemy_type):
			var enemy_instance = type._spawn(spawn_position)
			add_child(enemy_instance)
			enemies.append(enemy_instance)
			spawn_positions.append(spawn_position)
			
	var timer = get_node("Timer_" + enemy_type)
	_set_random_spawn_timer(timer, spawn_data[enemy_type])

func _is_valid_spawn_position(spawn_position: Vector2, enemy_type: String) -> bool:
	var min_distance = collapsed_building_min_distance if enemy_type == "CollapsedBuilding" else 150;
	for existing_position in spawn_positions:
		if position.distance_to(existing_position) < min_distance:
			return false;
	return true;
	
func _set_random_spawn_timer(timer: Timer, interval: Dictionary) -> void:
	var min_time = interval.get("min")
	var max_time = interval.get("max")
	if min_time >= max_time:
		push_error("El intervalo de spawn no es válido para el temporizador: " + timer.name)
		return
		
	timer.wait_time = randf_range(min_time, max_time)
	timer.start()
	
func _exit_tree() -> void:
	Instance = null;


func _on_random_event_triggered() -> void:
	camera_active = false;
	rain.start_rain()
	print("Rain starts!")
	_set_random_timer(event_duration_timer, random_event_duration)
	
func _on_event_finished() ->  void:
	rain.stop_rain()
	camera_active = true
	print("Rain finish!")
	_set_random_timer(event_timer, random_event_interval)
	
func _set_random_timer(timer: Timer, interval: Dictionary) -> void:
	var min_time = interval.get("min", 1.0)
	var max_time = interval.get("max", 2.0)
	timer.wait_time = randf_range(min_time, max_time)
	timer.start()
