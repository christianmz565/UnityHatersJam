extends AudioStreamPlayer2D
class_name AudioPlayer

enum Type { MUSIC, SFX }
@export var type: Type = Type.MUSIC

func _ready() -> void:
	if (type == Type.MUSIC):
		volume_db = pct_to_db(Globals.music_pct)
		Globals.connect("music_pct_changed", _on_volume_changed)
	elif (type == Type.SFX):
		volume_db = pct_to_db(Globals.sfx_pct)
		Globals.connect("sfx_pct_changed", _on_volume_changed)

func _on_volume_changed(pct: float) -> void:
	volume_db = pct_to_db(pct)

func pct_to_db(pct: float) -> float:
	return 20 * log(pct / 100) / log(10)
