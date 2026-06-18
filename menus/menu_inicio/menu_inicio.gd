extends Control
@onready var SELECTOR_NIVELES:String = "res://VFX/escena_transicion.tscn"
@onready var menu_opciones: Control = $MenuOpciones

func _ready() -> void:
	Dios.gestionar_bd_externa()
	Dios.equiparar_bases_directo()
	Dios.replicar_niveles_a_user()
	AudioManager.conectar_botones_del_menu(self)
	#AudioManager.menues.play()
	AudioManager.menues.stream_paused = false
	nivelar_audio_al_iniciar()
	
func menu_nivel():
	get_tree().change_scene_to_file(SELECTOR_NIVELES)
func salir():get_tree().quit()
func nivelar_audio_al_iniciar():
	menu_opciones.sonido.ajustar_volumen_al_maximo()
