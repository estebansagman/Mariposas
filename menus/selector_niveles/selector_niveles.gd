extends Control
@onready var MENU_INICIO:String = "res://menus/menu_inicio/menu_inicio.tscn"
@onready var nivel_elegido:String = "res://niveles/niveles/Nivel_1.tscn"
var nivel_seleccionado = false
@onready var alerta_seleccion: ColorRect = $AlertaSeleccion
@onready var alerta_bloqueo: ColorRect = $AlertaBloqueo

@onready var timer: Timer = $Timer
var indice:int
var sector_actual: int 

func seleccionar_nivel(nivel, indice_b, sector_b):
	nivel_seleccionado = true
	indice = indice_b
	sector_actual = sector_b
	nivel_elegido = nivel
	entrar_al_nivel()
	
func entrar_al_nivel():
	if not Dios.esta_desbloqueado(sector_actual, indice):
		timer.start()
		alerta_bloqueo.show()
		return
		
	if nivel_seleccionado:
		get_tree().change_scene_to_file(nivel_elegido)
	else: 
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
	alerta_bloqueo.hide()
