extends Control
class_name CatalogoPlantasH

const BOTON_PLANTA_H = preload("uid://fb28d6v5ky1k")

var keys_plantas:Array[String]
#@onready var contenedor_plantas: VBoxContainer = $ScrollContainer/ContenedorPlantas
var jardin: Jardin

func iniciar_catalogo(keys:Array[String],dato_jardin:Jardin):
	keys_plantas = keys.duplicate()
	jardin = dato_jardin
	_crear_catalogo()
	await get_tree().process_frame

func _crear_catalogo():
	for key_planta_completo in keys_plantas:
		var recorte = key_planta_completo.split(":")
		var key_planta = recorte[0]
		var key_estructura = recorte[1]
		var nuevo_boton_planta: BotonPlantaH = BOTON_PLANTA_H.instantiate()
		nuevo_boton_planta.ejemplar = key_planta_completo
		nuevo_boton_planta.key_planta = key_planta
		nuevo_boton_planta.key_estructura = key_estructura
		nuevo_boton_planta.pedido_de_planta.connect(jardin.origen_plantas.crear_planta)
		add_child(nuevo_boton_planta)
