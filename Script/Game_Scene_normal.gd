extends Node2D

var Game_Mode_Scene = load("res://Scenes/GameModeScene.tscn")
var Score_Scene_ez = load("res://Scenes/Score_easy_scene.tscn")

# Listas separadas para las posiciones de las notas
var normal_note_positions_y = [260, 253, 247, 240, 234, 227, 220, 214]
var sharp_note_positions_y = [260, 253, 240, 234, 227]
var flat_note_positions_y = [260, 253, 240, 234, 227]

var active_notes = []  # Array para mantener un registro de las notas generadas
var score = 0
var feedback_position = Vector2(320, 180)  # Ajusta la posición según sea necesario

@onready var perfect_sprite = preload("res://Img/Perfect score.png")
@onready var great_sprite = preload("res://Img/Great Score.png")
@onready var good_sprite = preload("res://Img/Good Score.png")
@onready var bad_sprite = preload("res://Img/Bad Score.png")
@onready var miss_sprite = preload("res://Img/Miss Score.png")
@onready var score_500_sprite = preload("res://Img/Score 500.png")
@onready var score_300_sprite = preload("res://Img/Score 300.png")
@onready var score_150_sprite = preload("res://Img/Score 150.png")
@onready var score_50_sprite = preload("res://Img/Score 50.png")
@onready var background_music = $Metronome
@onready var scene_timer = Timer.new()

# Nuevas texturas para notas sostenidas y bemoles
@onready var sharp_note_sprite = preload("res://Img/Note sos.png")
@onready var flat_note_sprite = preload("res://Img/Note bemol.png")

# Diccionario para almacenar la información de cada nota
var notes = {
	"do": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"dos": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"re": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"res": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"mi": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"fa": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"fas": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"sol": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"sols": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"la": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"las": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"si": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false},
	"do_oct": {"button": null, "audio": null, "normal_texture": null, "pressed_texture": null, "focus": false}
}

@onready var audio_nodes = [
	$"Do Sound", $"Dos Sound", $"Re Sound", $"Res Sound", $"Mi Sound", $"Fa Sound", $"Fas Sound",
	$"Sol Sound", $"Sols Sound", $"La Sound", $"Las Sound", $"Si Sound", $"Do oct Sound"
]

@onready var button_nodes = [
	$"Do note", $"Dos Button", $"Re Button", $"Res Button", $"Mi Button", $"Fa Button", $"Fas Button",
	$"Sol Button", $"Sols Button", $"La Button", $"Las Button", $"Si button", $"Do oct Button"
]

@onready var score_label = $"ScoreLabel"

func _ready():
	# Configurar el reproductor de música de fondo para que se reproduzca automáticamente
	background_music.play()

	# Configurar el temporizador para cambiar de escena después de 2 minutos
	scene_timer.wait_time = 120  # 2 minutos en segundos
	scene_timer.one_shot = true
	scene_timer.connect("timeout", Callable(self, "_on_scene_timeout"))
	add_child(scene_timer)
	scene_timer.start()

	# Inicializar el puntaje
	score = 0
	score_label.text = str(score)
	var note_keys = notes.keys()
	for i in range(note_keys.size()):
		var note = note_keys[i]
		notes[note]["button"] = button_nodes[i]
		notes[note]["audio"] = audio_nodes[i]
		notes[note]["normal_texture"] = notes[note]["button"].texture_normal
		notes[note]["pressed_texture"] = notes[note]["button"].texture_pressed

		notes[note]["button"].connect("focus_entered", Callable(self, "_on_focus_entered").bind(note))
		notes[note]["button"].connect("focus_exited", Callable(self, "_on_focus_exited").bind(note))
		notes[note]["audio"].connect("finished", Callable(self, "_on_sound_finished").bind(note))
		notes[note]["button"].connect("button_down", Callable(self, "_on_button_pressed").bind(note))

	# Asegurar que los botones puedan recibir el foco
	for note in notes.keys():
		notes[note]["button"].focus_mode = Control.FOCUS_ALL

	# Asignar foco inicial a todos los botones
	for note in notes.keys():
		notes[note]["button"].grab_focus()

	await get_tree().create_timer(1.0).timeout  # Esperar 3 segundos antes de empezar

	# Crear un temporizador para generar notas cada segundo
	var timer = Timer.new()
	timer.wait_time = 5
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)

func _on_scene_timeout():
	Global.score = score  # Actualiza la variable global con el puntaje actual
	get_tree().change_scene_to_packed(Score_Scene_ez)

func _on_timer_timeout():
	generate_random_note()

# Generar notas aleatoriamente
func generate_random_note():
	var note_area = Area2D.new()
	var note_sprite = Sprite2D.new()
	
	var note_type = randi() % 3  # 0: normal, 1: sostenido, 2: bemol
	var y_position = 0
	match note_type:
		0:
			note_sprite.texture = preload("res://Img/Note.png")
			y_position = normal_note_positions_y[randi() % normal_note_positions_y.size()]
		1:
			note_sprite.texture = sharp_note_sprite
			y_position = sharp_note_positions_y[randi() % sharp_note_positions_y.size()]
		2:
			note_sprite.texture = flat_note_sprite
			y_position = flat_note_positions_y[randi() % flat_note_positions_y.size()]

	note_area.add_child(note_sprite)
	note_area.position = Vector2(510, y_position) # Posición inicial en X es 510

	add_child(note_area)
	active_notes.append(note_area)  # Añadir la nota al array de notas activas

	# Crear y añadir un Tween para animar la nota
	var tween = create_tween()
	tween.tween_property(note_area, "position", Vector2(104, y_position), 5.0) # Punto final en X es 104

	# Eliminar la nota al final de la animación
	await get_tree().create_timer(5.0).timeout
	if note_area in active_notes:
		active_notes.erase(note_area)
		if note_area:
			note_area.queue_free()

func show_feedback(position: Vector2, feedback_type: String, score_value: int):
	var feedback_sprite = Sprite2D.new()
	var score_sprite = Sprite2D.new()

	# Seleccionar el sprite de feedback
	match feedback_type:
		"perfect":
			feedback_sprite.texture = perfect_sprite
		"great":
			feedback_sprite.texture = great_sprite
		"good":
			feedback_sprite.texture = good_sprite
		"bad":
			feedback_sprite.texture = bad_sprite
		"miss":
			feedback_sprite.texture = miss_sprite

	# Seleccionar el sprite de puntaje
	match score_value:
		500:
			score_sprite.texture = score_500_sprite
		300:
			score_sprite.texture = score_300_sprite
		150:
			score_sprite.texture = score_150_sprite
		50:
			score_sprite.texture = score_50_sprite
		_:
			score_sprite = null  # No mostrar puntaje para "miss"

	feedback_sprite.position = position + Vector2(-50, 0)  # Ajustar la posición a la izquierda
	add_child(feedback_sprite)

	if score_sprite:
		score_sprite.position = position + Vector2(50, 0)  # Ajustar la posición a la derecha
		add_child(score_sprite)

	# Eliminar los sprites después de un tiempo
	await get_tree().create_timer(1.0).timeout
	feedback_sprite.queue_free()
	if score_sprite:
		score_sprite.queue_free()

# Piano
func _input(event):
	if event is InputEventKey and event.pressed:
		var note_name = ""
		match event.keycode:
			Key.KEY_S:
				note_name = "do"
			Key.KEY_D:
				note_name = "re"
			Key.KEY_F:
				note_name = "mi"
			Key.KEY_G:
				note_name = "fa"
			Key.KEY_H:
				note_name = "sol"
			Key.KEY_J:
				note_name = "la"
			Key.KEY_K:
				note_name = "si"
			Key.KEY_L:
				note_name = "do_oct"
			Key.KEY_E:
				note_name = "dos"
			Key.KEY_R:
				note_name = "res"
			Key.KEY_Y:
				note_name = "fas"
			Key.KEY_U:
				note_name = "sols"
			Key.KEY_I:
				note_name = "las"

		if note_name != "":
			_on_button_pressed(note_name)

			# Encuentra la nota más a la izquierda
			var leftmost_note = null
			for note in active_notes:
				if leftmost_note == null or note.position.x < leftmost_note.position.x:
					leftmost_note = note

			if leftmost_note != null:
				var feedback_type = "miss"
				var score_value = 0

				# Validar la posición y tipo de nota para calcular el puntaje y mostrar feedback
				var note_sprite = leftmost_note.get_child(0)
				var is_sharp = note_sprite.texture == sharp_note_sprite
				var is_flat = note_sprite.texture == flat_note_sprite

				if leftmost_note.position.x >= 104 and leftmost_note.position.x <= 115:
					# La nota está en la zona "perfect"
					if is_sharp and validate_sharp(note_name, leftmost_note.position.y):
						score += 500
						feedback_type = "perfect"
						score_value = 500
					elif is_flat and validate_flat(note_name, leftmost_note.position.y):
						score += 500
						feedback_type = "perfect"
						score_value = 500
					elif validate_normal(note_name, leftmost_note.position.y):
						score += 500
						feedback_type = "perfect"
						score_value = 500

				elif leftmost_note.position.x >= 116 and leftmost_note.position.x <= 135:
					# La nota está en la zona "Great"
					if is_sharp and validate_sharp(note_name, leftmost_note.position.y):
						score += 300
						feedback_type = "great"
						score_value = 300
					elif is_flat and validate_flat(note_name, leftmost_note.position.y):
						score += 300
						feedback_type = "great"
						score_value = 300
					elif validate_normal(note_name, leftmost_note.position.y):
						score += 300
						feedback_type = "great"
						score_value = 300

				elif leftmost_note.position.x >= 136 and leftmost_note.position.x <= 152:
					# La nota está en la zona "Good"
					if is_sharp and validate_sharp(note_name, leftmost_note.position.y):
						score += 150
						feedback_type = "good"
						score_value = 150
					elif is_flat and validate_flat(note_name, leftmost_note.position.y):
						score += 150
						feedback_type = "good"
						score_value = 150
					elif validate_normal(note_name, leftmost_note.position.y):
						score += 150
						feedback_type = "good"
						score_value = 150

				elif leftmost_note.position.x >= 153 and leftmost_note.position.x <= 174:
					# La nota está en la zona "Bad"
					if is_sharp and validate_sharp(note_name, leftmost_note.position.y):
						score += 50
						feedback_type = "bad"
						score_value = 50
					elif is_flat and validate_flat(note_name, leftmost_note.position.y):
						score += 50
						feedback_type = "bad"
						score_value = 50
					elif validate_normal(note_name, leftmost_note.position.y):
						score += 50
						feedback_type = "bad"
						score_value = 50

				score_label.text = str(score)  # Actualizar el puntaje en pantalla
				show_feedback(feedback_position, feedback_type, score_value)
				remove_note_sprite(leftmost_note)

func validate_normal(note_name, y_position):
	return (note_name == "do" and y_position == 260) or (note_name == "re" and y_position == 253) or (note_name == "mi" and y_position == 247) or (note_name == "fa" and y_position == 240) or (note_name == "sol" and y_position == 234) or (note_name == "la" and y_position == 227) or (note_name == "si" and y_position == 220) or (note_name == "do_oct" and y_position == 214)

func validate_sharp(note_name, y_position):
	return (note_name == "dos" and y_position == 260) or (note_name == "res" and y_position == 253) or (note_name == "fas" and y_position == 240) or (note_name == "sols" and y_position == 234) or (note_name == "las" and y_position == 227)

func validate_flat(note_name, y_position):
	return (note_name == "dos" and y_position == 260) or (note_name == "res" and y_position == 253) or (note_name == "fas" and y_position == 240) or (note_name == "sols" and y_position == 234) or (note_name == "las" and y_position == 227)

func remove_note_sprite(note_sprite):
	if note_sprite in active_notes:
		active_notes.erase(note_sprite)
		if note_sprite:
			note_sprite.queue_free()

func _on_button_pressed(note):
	if notes[note]["button"].disabled:
		return

	notes[note]["button"].disabled = true
	notes[note]["audio"].play()
	notes[note]["button"].texture_normal = notes[note]["pressed_texture"]
	await get_tree().create_timer(0.5).timeout
	notes[note]["button"].texture_normal = notes[note]["normal_texture"]

func _on_sound_finished(note):
	notes[note]["button"].disabled = false

func _on_focus_entered(note):
	notes[note]["focus"] = true

func _on_focus_exited(note):
	notes[note]["focus"] = false

func _on_texture_button_pressed():
	get_tree().change_scene_to_packed(Game_Mode_Scene)
	AudioPlayer.play()
