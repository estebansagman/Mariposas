extends Control
class_name Interfas
signal reiniciar

@onready var SELECTOR_NIVELES:String = "res://VFX/escena_transicion.tscn"
@onready var MENU_INICIO = "res://menus/menu_inicio/menu_inicio.tscn"


@onready var catalogo_plantas: CatalogoPlantas = $CatalogoPlantas
@onready var catalogo_mariposas: Control = $CatalogoMariposas

@onready var alerta_seleccion: ColorRect = $AlertaSeleccion
@onready var cartel_final: Panel = %Cartel_final
@onready var timer: Timer = $Timer
@export var botones_debug: Control
@onready var estrella_ganado: TextureRect = $texto_nivel/PosicionEstrella/Estrella
@onready var fondo: TextureRect = $Camara/Fondo
@onready var titulo: NinePatchRect = $Titulo # ACAA (modificar)

@onready var libro_boton: TextureButton = $LibroBoton
@onready var texto_nivel: Label = $texto_nivel


##region EDITOR

#@onready var catalogo_plantas_B: CatalogoPlantas = $Control/CatalogoPlantas2
#@onready var catalogo_mariposas_B: CatalogoMariposas = $Control/CatalogoMariposas2
##endregion

#@onready var nine_patch_rect: NinePatchRect = $NinePatchRect

@onready var camara: Camera2D = %Camara

const ESTRELLA = preload("uid://dpw0savrm3hul")
const ESTRELLA_VFX = preload("uid://chooeh518y4dw")
@onready var highlight: ColorRect = $NinePatchRect/Highlight

var superado:bool = false

func _ready() -> void:
	catalogo_mariposas.quedarme.pressed.connect(ocultar_cartel)
	catalogo_mariposas.ir_a_niveles.pressed.connect(volver_al_menu)
	#poner_titulo_al_nivel("probando a ver si funca")
	
func poner_titulo_al_nivel(nombre):
	texto_nivel.text = nombre
	#var tamano_texto:float = texto.size.x
	#titulo.size.x = tamano_texto+300

	
func prender_estrella(activado:bool):
	if activado:
		estrella_ganado.show()
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
		libro_notif()

func libro_notif()->void:
	var t = create_tween()
	t.tween_interval(1.5)
	t.tween_property(libro_boton.get_child(1),"scale",Vector2(0.3,0.3),0.5)
	await t.finished
	libro_boton.update_notif(true)

func anim_win()->void:
	var tween = get_tree().create_tween();
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.VICTORIA)
	tween.tween_method(
	func(value): highlight.material.set_shader_parameter("Position", value),  
	  0.0,  # Start value
	  1.0,  # End value
	  2     # Duration
	);
	await tween.finished
	desplazar_camara()
	catalogo_mariposas.alargar_panel()
	#cartel_final.show()

func desplazar_camara()->void:
	var t = create_tween()
	t.tween_property(camara,"global_position",Vector2(540,540),1.2)

func highlight_mariposa()->void:
	for mariposa in get_parent().find_children("*","Mariposa",true,false):
		print("Highilight para ",mariposa)
		mariposa.agregar_highlight()

func anim_estrella()->void:
	var total_mariposas = get_parent().find_children("*","Mariposa",true,false)
	var contador = 0
	
	for mariposa in total_mariposas:
		contador += 1
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.POP_MULTI)
		var estrella:Path2D = ESTRELLA_VFX.duplicate(true).instantiate()
		var origin = mariposa.find_child("Sprite2D",true,false).global_position
		#var origin = %PosicionEstrella.global_position
		var t = create_tween()
		
		add_child(estrella,true)
		estrella.curve.add_point(%PosicionEstrella.global_position-origin,Vector2(400,200))
		#estrella.curve.add_point(Vector2(960,60)-origin,Vector2(400,200))
		estrella.z_index = 6
		estrella.global_position = origin
		var sprite = estrella.get_child(0).get_child(0)
		estrella.get_child(1).emitting = true
		sprite.scale = Vector2.ZERO

		t.tween_property(estrella.get_child(0),"progress_ratio",1.0,1.6)
		t.parallel()
		t.set_trans(Tween.TRANS_ELASTIC)
		t.tween_property(sprite,"scale",Vector2(0.2,0.2),1)

		if contador == total_mariposas.size():
			t.chain().tween_callback(func(): AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.POP))
func ocultar_cartel():
	#cartel_final.hide()
	catalogo_mariposas.restaurar_panel()
	restaurar_camara()

func volver_al_menu_principal():
	get_tree().paused = false
	get_tree().change_scene_to_file(MENU_INICIO)

func volver_al_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file(SELECTOR_NIVELES)

func reiniciar_nivel():
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.LEVEL_RESTART)
	get_tree().paused = false
	emit_signal("reiniciar")
	ocultar_cartel()
	#get_tree().reload_current_scene()

func restaurar_camara()->void:
	if camara.global_position == Vector2(960,540):
		return
	var t = create_tween()
	t.tween_property(camara,"global_position",Vector2(960,540),.8)
