extends Node2D

const bullet = preload("res://Scenes/Bullet/bullet.tscn")

@onready var marker: Marker2D = $Marker2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var audio_player: AudioPlayer = $AudioPlayer

@export var attack_speed: float = 0.5

var attack_timeout: bool = true

func _ready() -> void:
	timer.wait_time = attack_speed

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position());
	rotation_degrees = wrap(rotation_degrees, 0, 360);
	if Input.is_action_pressed("shoot_gun") and attack_timeout:
		shoot(_delta)

func shoot(_delta: float) -> void:
	var bullet_instance = bullet.instantiate();
	get_tree().root.add_child(bullet_instance);
	bullet_instance.global_position = marker.global_position;
	bullet_instance.rotation = rotation;
	timer.start()
	attack_timeout = false
	animated_sprite.play("shoot")
	audio_player.play()

func _on_timer_timeout() -> void:
	attack_timeout = true
	animated_sprite.play("idle")
