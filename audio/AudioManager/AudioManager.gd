extends Node2D
## Audio manager node. Inteded to be globally loaded as a 2D Scene. Handles [method create_2d_audio_at_location()] and [method create_audio()] to handle the playback and culling of simultaneous sound effects.
##
## To properly use, define [enum SoundEffect.SOUND_EFFECT_TYPE] for each unique sound effect, create a Node2D scene for this AudioManager script add those SoundEffect resources to this globally loaded script's [member sound_effects], and setup your individual SoundEffect resources. Then, use [method create_2d_audio_at_location()] and [method create_audio()] to play those sound effects either at a specific location or globally.
## 
## See https://github.com/Aarimous/AudioManager for more information.
##
## @tutorial: https://www.youtube.com/watch?v=Egf2jgET3nQ

var sound_effect_dict: Dictionary = {} ## Loads all registered SoundEffects on ready as a reference.
@export var sound_effects: Array[SoundEffect] ## Stores all possible SoundEffects that can be played.
@onready var menues: AudioStreamPlayer = $Menues
@onready var in_game_inicio: AudioStreamPlayer = $InGameInicio
@onready var in_game_loop: AudioStreamPlayer = $InGameLoop
@onready var audios_ambiente: VBoxContainer = $AudiosAmbiente
var audio_actual: AudioStreamPlayer = null

func _ready() -> void:
	menues.play()
	menues.stream_paused = true
	
	for sound_effect: SoundEffect in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect

	for hijo in audios_ambiente.get_children():
		if hijo is AudioStreamPlayer:
			hijo.finished.connect(_on_audio_ambiente_finished)
	
	reproducir_ambiente_aleatorio()

## Creates a sound effect at a specific location if the limit has not been reached. Pass [param location] for the global position of the audio effect, and [param type] for the SoundEffect to be queued.
func create_2d_audio_at_location(location: Vector2, type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_2D_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			add_child(new_2D_audio)
			new_2D_audio.bus = sound_effect.canal_audio
			new_2D_audio.position = location
			new_2D_audio.stream = sound_effect.sound_effect
			new_2D_audio.volume_db = sound_effect.volume
			new_2D_audio.pitch_scale = sound_effect.pitch_scale
			new_2D_audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness )
			new_2D_audio.finished.connect(sound_effect.on_audio_finished)
			new_2D_audio.finished.connect(new_2D_audio.queue_free)
			new_2D_audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)
## Creates a sound effect if the limit has not been reached. Pass [param type] for the SoundEffect to be queued.
func create_audio(type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(new_audio)
			new_audio.bus = sound_effect.canal_audio
			new_audio.stream = sound_effect.sound_effect
			new_audio.volume_db = sound_effect.volume
			new_audio.pitch_scale = sound_effect.pitch_scale
			new_audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness )
			new_audio.finished.connect(sound_effect.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)

func conectar_botones_del_menu(nodo_actual: Node) -> void:
	for hijo in nodo_actual.get_children():
		if hijo is BaseButton: 
			hijo.mouse_entered.connect(func(): create_audio(SoundEffect.SOUND_EFFECT_TYPE.BUTTON_HOVER))
			hijo.pressed.connect(func(): create_audio(SoundEffect.SOUND_EFFECT_TYPE.BUTTON_PRESS))
		
		if hijo.get_child_count() > 0:
			conectar_botones_del_menu(hijo)
func reproducir_musica_nivel() -> void:
	var tween = create_tween()
	tween.tween_property(menues, "volume_db", -80.0, 2)

	in_game_inicio.stop()
	in_game_loop.stop()
	in_game_inicio.stream_paused = false
	in_game_loop.stream_paused = false
	
	if in_game_inicio.finished.is_connected(_on_intro_terminada):
		in_game_inicio.finished.disconnect(_on_intro_terminada)
	in_game_inicio.finished.connect(_on_intro_terminada)
	
	in_game_inicio.play()
func _on_intro_terminada() -> void:
	in_game_loop.play()
	if in_game_inicio.finished.is_connected(_on_intro_terminada):
		in_game_inicio.finished.disconnect(_on_intro_terminada)
func volver_al_menu() -> void:
	in_game_inicio.stop()
	in_game_loop.stop()
	
	if in_game_inicio.finished.is_connected(_on_intro_terminada):
		in_game_inicio.finished.disconnect(_on_intro_terminada)
	
	menues.volume_db = 0.0
	menues.stream_paused = false
	#menues.play()
func reproducir_ambiente_aleatorio():
	var lista_audios = audios_ambiente.get_children()
	if lista_audios.is_empty():
		return
	var proximo_audio = lista_audios[randi() % lista_audios.size()]
	if lista_audios.size() > 1:
		while proximo_audio == audio_actual:
			proximo_audio = lista_audios[randi() % lista_audios.size()]
	audio_actual = proximo_audio
	audio_actual.play()
	print("Sonando ambiente: ", audio_actual.name)
func _on_audio_ambiente_finished():
	reproducir_ambiente_aleatorio()
