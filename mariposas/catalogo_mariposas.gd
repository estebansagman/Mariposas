extends Control
class_name CatalogoMariposas

const BOTON_MARIPOSA = preload("uid://6fvergr40whw")
#@export var control_tablero:ControlTablero
@onready var barra: VScrollBar = $VScrollBar
@onready var scroll: ScrollContainer = $ScrollContainer
@onready var contenedor_mariposas: VBoxContainer = $ScrollContainer/ContenedorMariposas
var mariposas_en_Juego:Array[Mariposa]
var mariposas:Array[RecursoMariposa]
#var jardin:Jardin
var barra_interna:VScrollBar

func iniciar_catalogo(datos:Array[RecursoMariposa]):
	mariposas = datos.duplicate()
	#jardin = dato_jardin
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
	if mariposas:
		for mariposa in mariposas:
			var nuevo_boton_mariposa:BotonMariposa = BOTON_MARIPOSA.instantiate()
			nuevo_boton_mariposa.recurso = mariposa
			#nuevo_boton_mariposa.control_tablero = control_tablero
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
