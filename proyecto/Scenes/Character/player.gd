extends CharacterBody2D

@export var speed: float = 400.0

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := GameInput.process_input();
	if direction != Vector2.ZERO:
		velocity = direction * speed
		move_and_slide()
