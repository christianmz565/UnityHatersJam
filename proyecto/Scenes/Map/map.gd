extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player

@export var camera_speed: float = 100.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if player:
		# Camera mid point
		var camera_mid_x = camera.global_position.x ;
		
		if player.global_position.x > camera_mid_x:
			camera.global_position.x += camera_speed * delta;
