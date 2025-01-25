extends Node2D


func _ready() -> void:
	await get_tree().create_timer(1.0).timeout;
	var spider_web = SpiderWeb._spawn(Vector2(250, 250));
	var serpent = Serpent._spawn(Vector2(-100, 0));
	var flies = Flies._spawn(Vector2(-100, 100));
	var collapsed = CollapsedBuilding._spawn(Vector2(-100, 0));
	add_child(spider_web);		
	add_child(serpent);
	add_child(flies);
	add_child(collapsed);
