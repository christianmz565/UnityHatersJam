extends CanvasLayer

# Texto de la historia dividido en partes
var story = [
	"En un mundo olvidado por los dioses...",
	"La paz que alguna vez reinó fue destruida por una oscuridad que nadie pudo detener.",
	"Solo un héroe podrá devolver la luz... o hundirlo todo en la eterna noche."
]

# Configuración de tiempo para la animación
var typing_speed = 0.05  # Velocidad de aparición de las letras
var current_text = ""  # Texto actual mostrado
var current_index = 0  # Índice de la frase actual
var timer

@onready var label = $Label

func _ready():
	# Configurar el Label para empezar vacío
	label.text = ""
	# Crear un timer para controlar la animación
	timer = Timer.new()
	add_child(timer)
	show_next_text()

func show_next_text():
	# Verifica si hay más texto en la historia
	if current_index < story.size():
		current_text = story[current_index]
		current_index += 1
		start_typing()
	else:
		# Finaliza la introducción o cambia de escena
		get_tree().change_scene("res://Scenes/Main/Global.tscn")  # Cambia a la escena principal del juego

func start_typing():
	label.text = ""  # Empieza con texto vacío
	var char_index = 0
	timer.start(typing_speed)
	timer.connect("timeout", self, "_on_typing", [char_index])

func _on_typing(char_index):
	# Mostrar el texto letra por letra
	if char_index < current_text.length():
		label.text += current_text[char_index]
		char_index += 1
	else:
		# Detener el timer y esperar interacción
		timer.stop()
		await get_tree().create_timer(2).timeout
		show_next_text()
