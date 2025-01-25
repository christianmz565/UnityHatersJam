extends RigidBody2D
class_name TestShip

static var Instance: TestShip;
@export var speed: float;

# prototype ship, since we will only have one ship in the game, we can use a singleton

func _ready() -> void:
	Instance = self;

func destroy():
	print("destroyed");
	visible = false;

func _physics_process(_delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	apply_force(speed * dir);
