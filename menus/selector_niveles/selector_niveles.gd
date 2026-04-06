extends Control
@onready var MENU_INICIO:String = "res://menus/menu_inicio/menu_inicio.tscn"
@onready var nivel_elegido:String = "res://niveles/niveles/Nivel_1.tscn"
var nivel_seleccionado = false
@onready var alerta_seleccion: ColorRect = $AlertaSeleccion
@onready var timer: Timer = $Timer

func seleccionar_nivel(nivel):
	nivel_seleccionado = true
	nivel_elegido = nivel
	
	
func entrar_al_nivel():
	if nivel_seleccionado:
		get_tree().change_scene_to_file(nivel_elegido)
	else: # cartel
		timer.start()
		alerta_seleccion.show()

func vovler_al_menu():
	get_tree().change_scene_to_file(MENU_INICIO)

func libro():
	pass

func pasar_de_zona():
	pass

func apagar_aletra():
	alerta_seleccion.hide()
