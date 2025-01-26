extends Control

@onready var score_label := $MainScoring/Shakeable/VBoxContainer/ScoreLabel
@onready var blink_anim := $AnimationPlayer
@onready var new_record_label := $MainScoring/Shakeable/VBoxContainer/NewRecordLabel
@onready var shakeable := $MainScoring/Shakeable
@onready var sfx_score := $SFXScore
@onready var music_score := $MusicScore
var sfx_pitch := 0.8
var anim_time: float = 0.0
var displayed_score := 0
var anim_done := false
var skip_anim := false

func _ready() -> void:
	if (Globals.current_score > Globals.best_score):
		new_record_label.visible = true;
	else:
		new_record_label.visible = false;
	Globals.best_score = Globals.current_score;

func _process(delta: float) -> void:
	_progress_anim(delta);

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.is_pressed()):
		if (not anim_done):
			skip_anim = true;
		else:
			SceneManager.change_scene("main_menu");

func _progress_anim(delta: float) -> void:
	if (not anim_done):
		anim_time += delta
	
		if displayed_score < Globals.current_score and not skip_anim:
			var increment = max(1, int(anim_time * 50));
			increment = min(increment, Globals.current_score - displayed_score);
			displayed_score += increment;

			shakeable.rotation += randf_range(-1, 1) * anim_time * 0.002;
			sfx_score.pitch_scale = sfx_pitch;
			sfx_pitch = min(sfx_pitch + 0.0003, 3);

			score_label.text = str(displayed_score).pad_zeros(6);
		else:
			displayed_score = Globals.current_score;
			score_label.text = str(displayed_score).pad_zeros(6);
			sfx_score.stop();
			music_score.play();
			blink_anim.play("blink");
			anim_done = true;
