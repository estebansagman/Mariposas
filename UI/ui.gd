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
const ESTRELLA = preload("uid://dpw0savrm3hul")
const ESTRELLA_VFX = preload("uid://chooeh518y4dw")



var superado:bool = false


func alerta_de_seleccion():
	alerta_seleccion.show()

func apagar_alerta_de_seleccion(): # esto se modifica, alerta reinicio
	alerta_seleccion.hide()

func superar_nivel():
	if !superado:
		await get_tree().create_timer(2).timeout
		anim_estrella()
		await get_tree().create_timer(1.2).timeout
		anim_win()
		#cartel_final.show()

func anim_win()->void:
	var vfx_light = HIGHLIGHT.instantiate()
	nine_patch_rect.add_child(vfx_light)
	await get_tree().create_timer(.8).timeout
	vfx_light.queue_free()
	#highlight_mariposa()
	#anim_estrella()
	catalogo_mariposas.animacion_ganar()

func highlight_mariposa()->void:
	#var jardin = get_tree().current_scene.find_child("Jardin")
	#printerr("Jardin es: ",jardin)
	#for mariposa in jardin.find_children("*","Mariposa",true,false):
	for mariposa in get_parent().find_children("*","Mariposa",true,false):
		print("Highilight para ",mariposa)
		mariposa.agregar_highlight()

#func anim_estrella()->void:
	#for mariposa in get_parent().find_children("*","Mariposa",true,false):
		#var estrella:Sprite2D = Sprite2D.new()
		#var t = create_tween()
		#estrella.scale = Vector2(2.0,2.0)
		#estrella.z_index = 6
		#estrella.texture = ESTRELLA
		#get_parent().add_child(estrella,true)
		#estrella.global_position = mariposa.find_child("Sprite2D",true,false).global_position
		#t.set_ease(Tween.EASE_IN)
		#t.set_trans(Tween.TRANS_BACK)
		#t.tween_property(estrella,"global_position",Vector2(960,60),1.0)


#func anim_estrella()->void:
	#printerr("Anim estrella")
	#for mariposa in get_parent().find_children("*","Mariposa",true,false):
		#var estrella:Path2D = ESTRELLA_VFX.instantiate()
		#var t = create_tween()
		#estrella.scale = Vector2(2.0,2.0)
		#estrella.global_rotation_degrees = randf_range(-180,180)
		##estrella.curve.add_point(Vector2(960,60))
		#estrella.z_index = 6
		#get_parent().add_child(estrella,true)
		#estrella.global_position = mariposa.find_child("Sprite2D",true,false).global_position
		#t.tween_property(estrella.get_child(0),"progress_ratio",1.0,1.6)
		#t.tween_property(estrella.get_child(0).get_child(0),"global_position",Vector2(960,60),0.4)


func anim_estrella()->void:
	for mariposa in get_parent().find_children("*","Mariposa",true,false):
		var estrella:Path2D = ESTRELLA_VFX.duplicate(true).instantiate()
		var origin = mariposa.find_child("Sprite2D",true,false).global_position
		var t = create_tween()
		get_parent().add_child(estrella,true)
		estrella.curve.add_point(Vector2(960,60)-origin,Vector2(400,200))
		estrella.z_index = 6
		estrella.global_position = origin
		var sprite = estrella.get_child(0).get_child(0)
		sprite.scale = Vector2.ZERO
		t.tween_property(estrella.get_child(0),"progress_ratio",1.0,1.6)
		t.parallel()
		t.set_trans(Tween.TRANS_ELASTIC)
		t.tween_property(sprite,"scale",Vector2(2.0,2.0),1)


func ocultar_cartel():
	cartel_final.hide()

func volver_al_menu():
	get_tree().change_scene_to_file(SELECTOR_NIVELES)

func reiniciar_nivel(): #este tiene que "recargarlo" de verdad, no reiniciar. corte "vaciar tablero"
	get_tree().reload_current_scene()
