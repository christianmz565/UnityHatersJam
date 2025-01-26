extends Control

@onready var music_slider := $Control/VBoxContainer/HBoxContainer/MusicSlider
@onready var sfx_slider := $Control/VBoxContainer/HBoxContainer2/SFXSlider

func _ready() -> void:
	music_slider.value = Globals.music_pct
	sfx_slider.value = Globals.sfx_pct

func _on_button_pressed() -> void:
	SceneManager.change_scene("main_game");

func _on_music_slider_value_changed(value: float) -> void:
	Globals.set_volume_pct(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	Globals.set_sfx_pct(value)
