extends CharacterBody2D

@export var speed: float = 400.0

func _physics_process(_delta: float) -> void:
	# Gets input direction
	var direction := GameInput.process_input();
	if direction != Vector2.ZERO:
		velocity = direction * speed
		move_and_slide()
