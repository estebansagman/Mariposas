extends Control

const TEXTO_DATO_CURIOSO = preload("uid://ca0tlk0b5ipan")
const ETIQUETA_REQUISITOS_LIBRO = preload("uid://bo5h8geremna8")


@onready var nombre_planta: Label = $HojaIzquierda/NombrePlanta
@onready var imagen_planta: TextureRect = $HojaIzquierda/TextureRect
@onready var mariposas_atraidas: VBoxContainer = $HojaDerecha/Control/ScrollContainer/Filas2
@onready var nombre_cientifico: Label = $HojaDerecha/NombreCientifico
@onready var datos_curiosos: VBoxContainer = $HojaDerecha/ScrollContainer2/Filas2

var planta_key: String
var oculto: String = "???"

func cargar_datos(key_planta):
	planta_key = key_planta
	
	cargar_nombre()
	cargar_imagen_planta()
	cargar_nombre_cientifico()
	cargar_mariposas_atraidas()
	#cargar_datos_curiosos_planta()

func cargar_nombre():
	var nombre = Dios.bd_interna["plantas"][planta_key]["nombre_comun"]
	nombre_planta.text = nombre

func cargar_imagen_planta():
	var textura = Dios.bd_interna["plantas"][planta_key]["imagen_libro"] 
	imagen_planta.texture = load(textura)

func cargar_nombre_cientifico():
	var nombre = Dios.bd_interna["plantas"][planta_key]["nombre_cientifico"]
	nombre_cientifico.text = nombre

func cargar_mariposas_atraidas():
	var elemento_inicial = mariposas_atraidas.get_child(0) if mariposas_atraidas.get_child_count() > 0 else null
	
	for i in range(1, mariposas_atraidas.get_child_count()):
		mariposas_atraidas.get_child(i).queue_free()
		
	var lista_mariposas = Dios.bd_interna["plantas"][planta_key]["mariposas_atraidas"]
	
	if lista_mariposas.is_empty():
		if elemento_inicial:
			elemento_inicial.show()
		return
		
	if elemento_inicial:
		elemento_inicial.hide()
		
	for m_id in lista_mariposas:
		var progreso = Dios.bd_externa["progreso_mariposas"][m_id]
		var esta_desbloqueada = false
		if progreso is Dictionary and not progreso.is_empty():
			esta_desbloqueada = true
		elif progreso is Array and not progreso.is_empty():
			esta_desbloqueada = true
			
		var instancia = ETIQUETA_REQUISITOS_LIBRO.instantiate()
		mariposas_atraidas.add_child(instancia)

		var nombre_mariposa = Dios.bd_interna["mariposas"][m_id]["nombre"]
		if esta_desbloqueada:
			instancia.acomodar_tamano(nombre_mariposa)
		else:
			instancia.acomodar_tamano("???")
