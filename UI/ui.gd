extends Control
class_name Interfas
signal reiniciar

@onready var SELECTOR_NIVELES:String = "res://menus/selector_niveles/selector_niveles.tscn"

@onready var catalogo_plantas: CatalogoPlantas = $CatalogoPlantas
@onready var catalogo_mariposas: Control = $CatalogoMariposas

@onready var alerta_seleccion: ColorRect = $AlertaSeleccion
@onready var cartel_final: Panel = $Cartel_final
@onready var timer: Timer = $Timer
@onready var botones_debug: Control = $botones_debug

#region EDITOR
@onready var control: ConfigCfg = $Control
@onready var catalogo_plantas_B: CatalogoPlantas = $Control/CatalogoPlantas2
@onready var catalogo_mariposas_B: CatalogoMariposas = $Control/CatalogoMariposas2
#endregion

@onready var nine_patch_rect: NinePatchRect = $NinePatchRect

const ESTRELLA = preload("uid://dpw0savrm3hul")
const ESTRELLA_VFX = preload("uid://chooeh518y4dw")
@onready var highlight: ColorRect = $NinePatchRect/Highlight

var superado:bool = false

func alerta_de_seleccion():
	alerta_seleccion.show()

func apagar_alerta_de_seleccion(): # esto se modifica, alerta reinicio
	alerta_seleccion.hide()

func superar_nivel():
	if !superado:
		#cartel_final.show()
		await get_tree().create_timer(2).timeout
		highlight_mariposa()
		anim_estrella()
		await get_tree().create_timer(1.2).timeout
		catalogo_mariposas.animacion_ganar()

func anim_win()->void:
	var tween = get_tree().create_tween();
	tween.tween_method(
	func(value): highlight.material.set_shader_parameter("Position", value),  
	  0.0,  # Start value
	  1.0,  # End value
	  2     # Duration
	);

func highlight_mariposa()->void:
	for mariposa in get_parent().find_children("*","Mariposa",true,false):
		print("Highilight para ",mariposa)
		mariposa.agregar_highlight()

func anim_estrella()->void:
	for mariposa in get_parent().find_children("*","Mariposa",true,false):
		var estrella:Path2D = ESTRELLA_VFX.duplicate(true).instantiate()
		var origin = mariposa.find_child("Sprite2D",true,false).global_position
		var t = create_tween()
		#get_parent().add_child(estrella,true)
		add_child(estrella,true)
		estrella.curve.add_point(Vector2(960,60)-origin,Vector2(400,200))
		estrella.z_index = 6
		estrella.global_position = origin
		var sprite = estrella.get_child(0).get_child(0)
		estrella.get_child(1).emitting = true
		print(estrella.get_child(1))
		sprite.scale = Vector2.ZERO
		t.tween_property(estrella.get_child(0),"progress_ratio",1.0,1.6)
		t.parallel()
		t.set_trans(Tween.TRANS_ELASTIC)
		t.tween_property(sprite,"scale",Vector2(2.0,2.0),1)

func ocultar_cartel():
	cartel_final.hide()

func volver_al_menu():
	get_tree().change_scene_to_file(SELECTOR_NIVELES)

func reiniciar_nivel():
	emit_signal("reiniciar")
	#get_tree().reload_current_scene()
