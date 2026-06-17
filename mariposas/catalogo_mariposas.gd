extends Control
class_name CatalogoMariposas

const BOTON_MARIPOSA = preload("uid://6fvergr40whw")
const PAPELPARAATRASDELASPOSTALES = preload("uid://biqi5q34myhyb")

@onready var barra: VScrollBar = $CatalogoMariposas/VScrollBar
@onready var scroll: ScrollContainer = $ScrollContainer
@onready var contenedor_mariposas: VBoxContainer = $ScrollContainer/ContenedorMariposas
@onready var cartel_victoria: HBoxContainer = %"Cartel Victoria"

@onready var quedarme: Button = %Quedarme
@onready var ir_a_niveles: Button = %IrANiveles

var mariposas_en_Juego:Array[Mariposa]
var keys_mariposas:Array[String]
var barra_interna:VScrollBar

var boton_libro
#func _ready() -> void:
	#tree_exiting.connect(reclamar_tree)
	#if get_tree().current_scene:
		#var boton_libro = get_tree().current_scene.find_child("LibroBoton")

#func reclamar_tree()->void:
	#get_tree().change_scene_to_node(self)
	#pass

func iniciar_catalogo(key_mariposas:Array[String]):
	keys_mariposas = key_mariposas.duplicate()
	_crear_catalogo()
	await get_tree().process_frame
	_sincronizar_barras()

func marcar_mariposas(mariposas_conseguidas:Array[Mariposa]):
	var lista_de_hijos: Array[BotonMariposa] = []
	lista_de_hijos.assign(contenedor_mariposas.get_children())
	for hijo in lista_de_hijos:
		for mariposa in mariposas_conseguidas:
			if hijo.indice == mariposa.id_mariposa:
				hijo.estrella.texture = load("res://menus/selector_niveles/imagenes/estrella.png")
				#hijo.estrella.modulate = Color(1, 1, 1, 1)
				break
			else:
				hijo.estrella.texture = load("res://UI/imagenes/estrella-vacia.png")
				#hijo.estrella.modulate = Color(0, 0, 0, 1)
		if mariposas_conseguidas.is_empty(): 
			hijo.estrella.texture = load("res://UI/imagenes/estrella-vacia.png")
			#hijo.texture_rect.modulate = Color(0, 0, 0, 1)

func _crear_catalogo():
	for key_mariposa in keys_mariposas:
		var nuevo_boton_mariposa:BotonMariposa = BOTON_MARIPOSA.instantiate()
		nuevo_boton_mariposa.key_mariposa = key_mariposa
		contenedor_mariposas.add_child(nuevo_boton_mariposa)

func _sincronizar_barras():
	barra_interna = scroll.get_v_scroll_bar()
	barra.max_value = barra_interna.max_value
	barra.page = barra_interna.page
	barra_interna.changed.connect(_actualizar_propiedades)
	barra_interna.value_changed.connect(_scroll_interno)

func _actualizar_propiedades():
	barra.max_value = barra_interna.max_value
	barra.page = barra_interna.page

func _barra_movida(v):
	scroll.scroll_vertical = int(v)

func _scroll_interno(v):
	barra.value = v

func animacion_ganar()->void:
	boton_libro = get_tree().current_scene.find_child("LibroBoton")
	var duration = 1.3
	var delay = 0.3
	var final_pos = boton_libro.global_position+Vector2(30,60)
	for mariposa:BotonMariposa in contenedor_mariposas.get_children():
		var original_pos = mariposa.global_position+Vector2(64,0)
		var elemento = Sprite2D.new()
		var t = create_tween()
		
		t.finished.connect(tween_libro)
		#connect(t.finished,tween_libro,CONNECT_ONE_SHOT)
		
		t.set_ease(Tween.EASE_IN)
		t.set_trans(Tween.TRANS_BACK)
		add_child(elemento)
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PAPEL_FLY)
		elemento.texture = PAPELPARAATRASDELASPOSTALES
		elemento.scale = Vector2(.1,.1)
		#elemento.top_level = true
		elemento.global_position = original_pos
		#elemento.pivot_offset_ratio = Vector2(0.5,0.5)
		t.tween_property(elemento,"global_position",final_pos,duration)
		t.set_parallel(true)
		#t.set_trans(Tween.TRANS_QUINT)
		t.set_trans(Tween.TRANS_SPRING)
		t.tween_property(elemento,"scale",Vector2(0.03,0.03),duration)
		#t.tween_property(mariposa,"modulate",Color(16, 16, 16, 1.0),duration/3)
		await get_tree().create_timer(delay).timeout
		
		
		#elemento.modulate = Color(16, 16, 16, 1.0)

@onready var catalogo_mariposas: NinePatchRect = $CatalogoMariposas
func alargar_panel()->void:
	printerr("ALARGAR PANEL")
	var t = create_tween()
	t.tween_property(catalogo_mariposas,"custom_minimum_size",Vector2(800,catalogo_mariposas.custom_minimum_size.y),2.0).set_trans(Tween.TRANS_QUAD)
	t.parallel()
	t.tween_interval(.5)
	t.tween_property(cartel_victoria,"scale",Vector2.ONE,1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#t.tween_property(cartel_victoria,"modulate",Color.WHITE,2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	#quedarse.disabled = false
	#ir_a_niveles.disabled = false
	#cartel_victoria.visible = true

func restaurar_panel()->void:
	var t = create_tween()
	#cartel_victoria.modulate=Color(1,1,1,0)
	t.tween_property(catalogo_mariposas,"custom_minimum_size",Vector2(0,catalogo_mariposas.custom_minimum_size.y),1.6)
	t.parallel()
	t.tween_property(cartel_victoria,"scale",Vector2(1,0),.8).set_trans(Tween.TRANS_BACK)
	#quedarse.disabled = true
	#ir_a_niveles.disabled = true
	#cartel_victoria.visible = false

func tween_libro()-> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PAPEL_INSERT)
	var tl = create_tween()
	tl.tween_property(boton_libro,"scale",Vector2(1.3,1.3),0.1)
	tl.tween_property(boton_libro,"scale",Vector2(1.149,1.149),0.1)
