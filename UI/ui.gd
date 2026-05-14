extends Control
class_name Interfas
signal pasar_nivel

@onready var SELECTOR_NIVELES:String = "res://menus/selector_niveles/selector_niveles.tscn"

@onready var catalogo_plantas: CatalogoPlantas = $CatalogoPlantas
@onready var catalogo_mariposas: Control = $CatalogoMariposas

@onready var alerta_seleccion: ColorRect = $AlertaSeleccion
@onready var cartel_final: Panel = $Cartel_final
@onready var timer: Timer = $Timer
@onready var botones_debug: Control = $botones_debug


var superado:bool = false


func alerta_de_seleccion():
	alerta_seleccion.show()

func apagar_alerta_de_seleccion(): # esto se modifica, alerta reinicio
	alerta_seleccion.hide()

func superar_nivel():
	if !superado:
		cartel_final.show()

func ocultar_cartel():
	cartel_final.hide()

func volver_al_menu():
	get_tree().change_scene_to_file(SELECTOR_NIVELES)

func reiniciar_nivel(): #este tiene que "recargarlo" de verdad, no reiniciar. corte "vaciar tablero"
	get_tree().reload_current_scene()
