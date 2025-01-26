extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player
@onready var line: Line2D = $Line2D

var max_camera_x: float = 0.0
@export var camera_speed: float = 100.0

func _ready() -> void:
	max_camera_x = camera.global_position.x

func _process(delta: float) -> void:
	if player:
		# Camera mid point
		
		
		var camera_mid_x = camera.global_position.x ;
		line.global_position.x = camera.global_position.x
	
		
		if player.global_position.x > camera_mid_x:
			camera.global_position.x += camera_speed * delta;
