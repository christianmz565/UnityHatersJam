extends CharacterBody2D
class_name Player

@export var speed: float = 400.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

static var Instance: Player

func _ready() -> void:
	Instance = self;
	

func _physics_process(_delta: float) -> void:
	# Gets input direction
	var direction := GameInput.process_input();
	if direction != Vector2.ZERO:
		velocity = direction * speed;
		move_and_slide();
	
func destroy() -> void:
	visible = false;
	print("Perdiste");
