extends Node

var currentScene: Node;
var transition_rect: ColorRect;
var gameScenes = {
	"main_menu": preload("res://Scenes/Main/MainMenu.tscn"),
	"main_game": preload("res://Scenes/Map/map.tscn"),
	"main_scoring": preload("res://Scenes/Main/MainScoring.tscn")
};

func _setup():
	change_scene("main_menu");

func change_scene(to: String):
	_deferred_change_scene.call_deferred(to);
	
func _deferred_change_scene(to: String):
	if (currentScene):
		currentScene.queue_free();
	currentScene = gameScenes[to].instantiate();
	get_tree().root.add_child(currentScene);
