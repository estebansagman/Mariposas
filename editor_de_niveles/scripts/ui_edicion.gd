extends Control
class_name Interfas_herramienta
signal reiniciar
signal objetos_swichearon(prendido:bool)

@onready var SELECTOR_NIVELES:String = "res://menus/selector_niveles/selector_niveles.tscn"
@onready var MENU_INICIO = "res://menus/menu_inicio/menu_inicio.tscn"

@export var catalogo_plantas: CatalogoPlantasH 
@export var catalogo_mariposas: CatalogoMariposasH
@export var catalogo_objetos: CatalogoObjetosH
@export var control: ConfigCfg

@onready var alerta_seleccion: ColorRect = $AlertaSeleccion
@onready var cartel_final: Panel = %Cartel_final
@onready var botones_debug: Control = $botones_debug
#@onready var control: ConfigCfg = $MarginContainer/PanelGeneral/Panel2/VBoxContainer2/HBoxContainer2/Control2/VBoxContainer2/ColorRect2/MarginContainer/Control
@onready var posicion_tablero: Control = $PosicionTablero

var superado:bool = false

func alerta_de_seleccion():
	alerta_seleccion.show()
func apagar_alerta_de_seleccion(): # esto se modifica, alerta reinicio
	alerta_seleccion.hide()
func avisar_swich_funcion_de_objetos(prendido):
	print("AAAAAAAAAAAAAAAAAAAA")
	emit_signal("objetos_swichearon",prendido)

func volver_al_menu_principal():
	get_tree().change_scene_to_file(MENU_INICIO)
func volver_al_menu():
	get_tree().change_scene_to_file(SELECTOR_NIVELES)
func reiniciar_nivel():
	emit_signal("reiniciar")
