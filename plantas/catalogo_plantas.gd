extends Control

const BOTON_PLANTA = preload("uid://ditlo36hekgcp")
@export var plantas:Array[RecursoPlanta]
@export var control_tablero:ControlTablero
@onready var contenedor_plantas: VBoxContainer = $ScrollContainer/ContenedorPlantas
@onready var barra: VScrollBar = $VScrollBar
@onready var scroll: ScrollContainer = $ScrollContainer

@onready var origen_plantas: Node2D = $"../Jardin/origen_plantas"
var barra_interna:VScrollBar

func _ready():
	_crear_catalogo()
	await get_tree().process_frame
	_sincronizar_barras()

func _crear_catalogo():
	if plantas:
		for planta in plantas:
			var nuevo_boton_planta: BotonPlanta = BOTON_PLANTA.instantiate()
			nuevo_boton_planta.recurso = planta
			nuevo_boton_planta.pedido_de_planta.connect(origen_plantas._on_pedido_de_planta)
			contenedor_plantas.add_child(nuevo_boton_planta)

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
