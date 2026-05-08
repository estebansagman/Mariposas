extends Control
class_name CatalogoPlantas

const BOTON_PLANTA = preload("uid://ditlo36hekgcp")
var keys_plantas:Array[String]
@onready var contenedor_plantas: VBoxContainer = $ScrollContainer/ContenedorPlantas
@onready var barra: VScrollBar = $VScrollBar
@onready var scroll: ScrollContainer = $ScrollContainer

var jardin: Jardin
var barra_interna:VScrollBar

func iniciar_catalogo(keys:Array[String],dato_jardin:Jardin):
	keys_plantas = keys.duplicate()
	jardin = dato_jardin
	_crear_catalogo()
	await get_tree().process_frame
	_sincronizar_barras()

func _crear_catalogo():
	#if Dios.bd_interna["plantas"].has(keys_plantas[0]):
	for key_planta_completo in keys_plantas:
		var recorte = key_planta_completo.split(":")
		var key_planta = recorte[0]
		var key_estructura = recorte[1]

		var nuevo_boton_planta: BotonPlanta = BOTON_PLANTA.instantiate()
		#nuevo_boton_planta.inicio()
		nuevo_boton_planta.key_planta = key_planta
		nuevo_boton_planta.key_estructura = key_estructura
		nuevo_boton_planta.pedido_de_planta.connect(jardin.origen_plantas.crear_planta)
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
