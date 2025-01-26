extends Node

var currentScene: Node;
var transition_anim: AnimationPlayer;
var gameScenes = {
	"main_menu": preload("res://Scenes/Main/MainMenu.tscn"),
	"main_game": preload("res://Scenes/Main/MainGame.tscn"),
	"main_scoring": preload("res://Scenes/Main/MainScoring.tscn"),
};

func _setup(p_transition_anim: AnimationPlayer):
	transition_anim = p_transition_anim;
	change_scene("main_menu");

func change_scene(to: String):
	_deferred_change_scene.call_deferred(to);
	
func _deferred_change_scene(to: String):
	if (currentScene):
		transition_anim.play("fade_in");
		await transition_anim.animation_finished;
		currentScene.queue_free();
	currentScene = gameScenes[to].instantiate();
	get_tree().root.add_child(currentScene);
	transition_anim.play("fade_out");
