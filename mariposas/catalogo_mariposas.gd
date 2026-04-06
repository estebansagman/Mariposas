extends Control

const BOTON_MARIPOSA = preload("uid://6fvergr40whw")
@export var mariposas:Array[RecursoMariposa]
@export var control_tablero:ControlTablero
@onready var contenedor_mariposas: VBoxContainer = $ScrollContainer/ContenedorMariposas
@onready var barra: VScrollBar = $VScrollBar
@onready var scroll: ScrollContainer = $ScrollContainer

func _ready():
	_crear_catalogo()
	await get_tree().process_frame
	_sincronizar_barras()

func _crear_catalogo():
	if mariposas:
		for mariposa in mariposas:
			var nuevo_boton_mariposa:BotonMariposa = BOTON_MARIPOSA.instantiate()
			nuevo_boton_mariposa.recurso = mariposa
			nuevo_boton_mariposa.control_tablero = control_tablero
			contenedor_mariposas.add_child(nuevo_boton_mariposa)
	
func _sincronizar_barras():
	var barra_interna = scroll.get_v_scroll_bar()
	barra.max_value = barra_interna.max_value
	barra.page = barra_interna.page
	barra.value_changed.connect(_barra_movida)
	barra_interna.value_changed.connect(_scroll_interno)

func _barra_movida(v):
	scroll.scroll_vertical = int(v)

func _scroll_interno(v):
	barra.value = v
