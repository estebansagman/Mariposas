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

@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
const HIGHLIGHT = preload("uid://dshrtbs2itfh0")

var superado:bool = false


func alerta_de_seleccion():
	alerta_seleccion.show()

func apagar_alerta_de_seleccion(): # esto se modifica, alerta reinicio
	alerta_seleccion.hide()

func superar_nivel():
	if !superado:
		anim_win()
		cartel_final.show()
		catalogo_mariposas.animacion_ganar()

func anim_win()->void:
	var vfx_light = HIGHLIGHT.instantiate()
	nine_patch_rect.add_child(vfx_light)
	await get_tree().create_timer(1.4).timeout
	vfx_light.queue_free()
	highlight_mariposa()

func highlight_mariposa()->void:
	#var jardin = get_tree().current_scene.find_child("Jardin")
	#printerr("Jardin es: ",jardin)
	#for mariposa in jardin.find_children("*","Mariposa",true,false):
	for mariposa in get_parent().find_children("*","Mariposa",true,false):
		print("Highilight para ",mariposa)
		mariposa.agregar_highlight()

func ocultar_cartel():
	cartel_final.hide()

func volver_al_menu():
	get_tree().change_scene_to_file(SELECTOR_NIVELES)

func reiniciar_nivel(): #este tiene que "recargarlo" de verdad, no reiniciar. corte "vaciar tablero"
	get_tree().reload_current_scene()
