extends Control

@onready var score_label := $MainScoring/Shakeable/VBoxContainer/ScoreLabel
@onready var firework_particles := $Fireworks
@onready var bubble_particles := $Bubbles
@onready var blink_anim := $AnimationPlayer
@onready var new_record_label := $MainScoring/Shakeable/VBoxContainer/NewRecordLabel
@onready var shakeable := $MainScoring/Shakeable
var anim_time: float = 0.0
var displayed_score := 0

func _ready() -> void:
	if (Globals.current_score > Globals.best_score):
		firework_particles.emitting = true;
		bubble_particles.emitting = false;
		new_record_label.visible = true;
	else:
		firework_particles.emitting = false;
		bubble_particles.emitting = true;
		new_record_label.visible = false;

func _process(delta: float) -> void:
	anim_time += delta
	
	if displayed_score < Globals.current_score:
		var increment = max(1, int(anim_time * 50));
		increment = min(increment, Globals.current_score - displayed_score);
		displayed_score += increment;

		shakeable.rotation += randf_range(-1, 1) * anim_time * 0.001;

		score_label.text = str(displayed_score).pad_zeros(6);
	else:
		blink_anim.play("blink");
