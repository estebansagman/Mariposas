extends Control
class_name CatalogoMariposas

const BOTON_MARIPOSA = preload("uid://6fvergr40whw")

@onready var barra: VScrollBar = $VScrollBar
@onready var scroll: ScrollContainer = $ScrollContainer
@onready var contenedor_mariposas: VBoxContainer = $ScrollContainer/ContenedorMariposas
var mariposas_en_Juego:Array[Mariposa]
var keys_mariposas:Array[String]

var barra_interna:VScrollBar

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
				hijo.texture_rect.modulate = Color(1, 1, 1, 1)
				break
			else:
				hijo.texture_rect.modulate = Color(0, 0, 0, 1)
		if mariposas_conseguidas.is_empty(): 
			hijo.texture_rect.modulate = Color(0, 0, 0, 1)

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
	var final_pos = Vector2(0.0,2000.0)
	var duration = 1.3
	var delay = 0.2
	if get_tree().current_scene.find_child("LibroBoton"):
		final_pos = get_tree().current_scene.find_child("LibroBoton").global_position
	for mariposa:BotonMariposa in contenedor_mariposas.get_children():
		var original_pos = mariposa.global_position
		var t = create_tween()
		t.set_ease(Tween.EASE_IN)
		t.set_trans(Tween.TRANS_BACK)
		mariposa.top_level = true
		mariposa.global_position = original_pos
		mariposa.pivot_offset_ratio = Vector2(0.5,0.5)
		t.tween_property(mariposa,"global_position",Vector2(original_pos.x,final_pos.y),duration)
		t.set_parallel(true)
		#t.set_trans(Tween.TRANS_QUINT)
		t.set_trans(Tween.TRANS_SPRING)
		t.tween_property(mariposa,"scale",Vector2.ZERO,duration)
		#t.tween_property(mariposa,"modulate",Color(16, 16, 16, 1.0),duration/3)
		await get_tree().create_timer(delay).timeout
		mariposa.modulate = Color(16, 16, 16, 1.0)
