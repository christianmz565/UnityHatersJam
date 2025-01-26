extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sender_label: Label = $ColorRect/VBoxContainer/Sender
@onready var message_label: RichTextLabel = $ColorRect/VBoxContainer/Text
var is_showing: bool = false
var dialogue_queue: Array = []
var write_delay: float = 0.025
var dialogue_delay: float = 1

func _ready() -> void:
	visible = false;
	send_dialogues(
		[
			["Narrator", "Welcome to the game!"],
			["Narrator", "Press the arrow keys to move around."],
			["Narrator", "Press the space bar to jump."],
			["Narrator", "Collect coins to increase your score."],
			["Narrator", "Avoid the obstacles to stay alive."],
			["Narrator", "Good luck!"]
		]
	)

func send_dialogues(dialogues: Array) -> void:
	for dialogue in dialogues:
		dialogue_queue.append(dialogue);
	if not is_showing:
		_process_queue();

func send_dialogue(p_sender: String, p_message: String) -> void:
	dialogue_queue.append([p_sender, p_message]);
	if not is_showing:
		_process_queue();

func _process_queue() -> void:
	is_showing = true;
	visible = true;
	anim_player.play("diag_in");
	await anim_player.animation_finished;
	
	while dialogue_queue.size() > 0:
		var current_dialogue: Array = dialogue_queue.pop_front();
		await _process_single_dialogue(current_dialogue[0], current_dialogue[1]);

	anim_player.play("diag_out");
	await anim_player.animation_finished;
	visible = false;
	is_showing = false;

func _process_single_dialogue(p_sender: String, p_message: String):
	sender_label.text = p_sender;
	message_label.text = "";

	for i in range(len(p_message)):
		message_label.text += p_message[i];
		await get_tree().create_timer(write_delay).timeout;
	
	await get_tree().create_timer(dialogue_delay).timeout;
