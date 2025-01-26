extends Node

var music_pct := 50.0
var sfx_pct := 50.0
var best_score := 0
var current_score := 236512

signal music_pct_changed
signal sfx_pct_changed

func set_volume_pct(value: float) -> void:
	music_pct = value
	emit_signal("music_pct_changed", music_pct)

func set_sfx_pct(value: float) -> void:
	sfx_pct = value
	emit_signal("sfx_pct_changed", sfx_pct)

func get_rand_pos_neg():
	return (-1 if randf() >= 0.5 else 1);
