extends Node2D

const bullet = preload("res://Scenes/Bullet/bullet.tscn")

@onready var marker: Marker2D = $Marker2D
@onready var timer: Timer = $Timer

@export var attack_speed: float = 0.5

var attack_timeout: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = attack_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position());
	rotation_degrees = wrap(rotation_degrees, 0, 360);
	if 90 < rotation_degrees and rotation_degrees < 270:
		scale.y = -1;
	else:
		scale.y = 1;

	if Input.is_action_pressed("shoot_gun") and attack_timeout:
		shoot(_delta)

func shoot(_delta: float) -> void:
	var bullet_instance = bullet.instantiate();
	get_tree().root.add_child(bullet_instance);
	bullet_instance.global_position = marker.global_position;
	bullet_instance.rotation = rotation;
	timer.start()
	attack_timeout = false


func _on_timer_timeout() -> void:
	attack_timeout = true
