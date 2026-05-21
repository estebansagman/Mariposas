extends Node2D
class_name NivelJugable2

@export var numero_de_nivel:int
@export var numero_de_sector: int
@export var jardin:Jardin

var label_mouse: Label
var panel_mouse: PanelContainer

@onready var sector = "seccion_" + str(numero_de_sector)
@onready var nivel = "nivel_" + str(numero_de_nivel)

@export_enum(
	"bandera_argentina",
	"cuatro_ojos",
	"espejito",
	"limonero",
	"perezosa",
	"bataraza"
	) var Especie_mariposa:Array[String]
@export_enum(
	"ceibo:A",
	"ceibo:B",
	"coronillo:A",
	"coronillo:B",
	"chilca:A",
	"chilca:B",
	"ruda:A",
	"ruda:B",
	"canario_rojo:A",
	"canario_rojo:B",
	"salvia:A",
	"salvia:B",
	"ruelia:A",
	"ruelia:B",
	"mbrucuya:A",
	"mbrucuya:B",
	"lantana:A",
	"lantana:B"
	) var Especie_planta:Array[String]	
@export var datos_de_libro:Array[Recompensa]

@onready var ui: Interfas = $UI
@onready var pasar_de_nivel: Timer = $PasarDeNivel

var estrellas:int
var puntos_maximos:int

const PLANTA = preload("uid://der8d61kw3xr8")


@onready var ejemplares: Dictionary = {
	"ceibo:A": preload("uid://crq4cgvp4qndp"),
	"ceibo:B": preload("uid://2u2bwrxrncp8"),
	"coronillo:A": preload("uid://c6pikhlq2a5qb"),
	"coronillo:B": preload("uid://cm37ht5virdhf"),
	"chilca:A": preload("uid://be5rky35pqp3r"),
	"chilca:B": preload("uid://ch5ki13fftmxd"),
	"ruda:A":preload("uid://cct63xday235l"),
	"ruda:B":preload("uid://8e1vimfhtjui"),
	"canario_rojo:A": preload("uid://d1l7h3nujrv18"),
	"canario_rojo:B":preload("uid://cbetjqdfqna7d"),
	"salvia:A":preload("uid://77r4p80njc3n"),
	"salvia:B":preload("uid://da6yggwa6opv3"),
	"ruelia:A":preload("uid://d2wxv30mfljv8"),
	"ruelia:B":preload("uid://h53ufbp7l6l3"),
	"mbrucuya:A":preload("uid://dm6ahndnly2dq"),
	"mbrucuya:B":preload("uid://cyfohd827w3ag"),
	"lantana:A":preload("uid://bfqa5wgnffhbk"),
	"lantana:B":preload("uid://cjux6woqbm3fc")
}

func _input(event: InputEvent) -> void:
	var posicion_mouse_local = jardin.tablero.get_local_mouse_position()
	var casillero_tablero: Vector2i = jardin.tablero.local_to_map(posicion_mouse_local)
	var nombre_planta = jardin.tablero.get_nombre_planta(casillero_tablero)
	
	#print(nombre_planta)
	
	if panel_mouse:
		panel_mouse.global_position = get_global_mouse_position() + Vector2(15, 15)
		
		if nombre_planta != "":
			label_mouse.text = nombre_planta
			panel_mouse.show()
		else:
			panel_mouse.hide()

func _ready() -> void:
	jardin.tablero._generar_grilla()
	
	panel_mouse = PanelContainer.new()
	label_mouse = Label.new()
	panel_mouse.add_child(label_mouse)
	add_child(panel_mouse)
	
	panel_mouse.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label_mouse.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var orden_importancia = Dios.bd_interna["orden_inportancia_mariposas"]
	var especies_ordenadas: Array[String] = []
	
	for nombre_mariposa in orden_importancia:
		if Especie_mariposa.has(nombre_mariposa):
			especies_ordenadas.append(nombre_mariposa)
			
	Especie_mariposa = especies_ordenadas

	jardin.naturaleza.generar_mariposas(Especie_mariposa)
	ui.catalogo_plantas.iniciar_catalogo(Especie_planta, jardin)
	ui.catalogo_mariposas.iniciar_catalogo(Especie_mariposa)
	sistema_debug()
	#estado_nivel = Dios.bd_externa["sectores"][s_id]["niveles"][nivel_id]["superado"]

func sumar_puntos():
	return
	var mariposas_jugadas:Array[Mariposa] = jardin.naturaleza.mariposas_en_juego.duplicate()
	ui.catalogo_mariposas.marcar_mariposas(mariposas_jugadas)
	if Especie_mariposa.size() == mariposas_jugadas.size():
		var s_id = "seccion_" + str(numero_de_sector)
		var nivel_id = "nivel_" + str(numero_de_nivel)
		var estado_nivel = Dios.bd_externa["sectores"][s_id]["niveles"][nivel_id]["superado"]
		ui.superar_nivel()
		if !estado_nivel:
			completar_nivel()
			revelar_datos()
		#pasar_de_nivel.start()

func completar_nivel():
	var sector_id = "seccion_" + str(numero_de_sector)
	var nivel_id = "nivel_" + str(numero_de_nivel)
	Dios.bd_externa["sectores"][sector_id]["niveles"][nivel_id]["superado"] = true
	Dios.bd_externa["sectores"][sector_id]["niveles_superados"] += 1
	Dios.guardar_bd_externa()

func revelar_datos():
	var sector_id = "seccion_" + str(numero_de_sector)
	var nivel_id = "nivel_" + str(numero_de_nivel)
	if datos_de_libro:
		for recompensa in datos_de_libro:
			var mariposa_id = recompensa.mariposa
			if not Dios.bd_externa["progreso_mariposas"].has(mariposa_id):
				Dios.bd_externa["progreso_mariposas"][mariposa_id] = []
			for dato in recompensa.dato_mariposa:
				if dato not in Dios.bd_externa["progreso_mariposas"][mariposa_id]:
					var clave = Dios.bd_interna["mariposas"][mariposa_id][dato]
					Dios.bd_externa["progreso_mariposas"][mariposa_id].append(clave)
	Dios.guardar_bd_externa()

func guardar_estado_de_tablero(tablero):
	Dios.bd_externa["sectores"][sector][nivel]["momento_de_juego"] = tablero
	Dios.guardar_bd_externa()
	
func volver_al_Menu():
	get_tree().change_scene_to_file(ui.SELECTOR_NIVELES)

func sistema_debug(): #despues borrar
	ui.botones_debug.nivel_jugandose = self
	
func guardar_estado_de_nivel():
	var texto_sector = "sector_" + str(numero_de_sector)
	var texto_nivel = "Nivel_" + str(numero_de_nivel)
	var ruta_base = "res://niveles/niveles/" + texto_sector + "/" + texto_nivel + ".cfg"
	
	var el_tablero = jardin.tablero
	var diccionario_crudo = el_tablero.celdas
	var diccionario_limpio = {}
	for celda in diccionario_crudo:
		var info_celda = diccionario_crudo[celda].duplicate()
		info_celda[el_tablero.key_planta] = ""
		diccionario_limpio[celda] = info_celda

	var lista_plantas_puras = []
	var plantas_vivas = jardin.jardinero.plantas_en_tablero.duplicate()

	for planta:Planta in plantas_vivas:
		var datos_planta = {
			"key_planta": planta.key_planta,
			"id_planta": planta.id_planta,
			"key_estructura":planta.key_estructura,
			"estructura": planta.estructura,
			"giro_actual": planta.giro_actual,
			"ejemplar": planta.ejemplar,
			"coordenada_celda": planta.coordenada_celda
		}
		lista_plantas_puras.append(datos_planta)

	var config = ConfigFile.new()
	config.set_value("Tablero", "datos_celdas", diccionario_limpio)
	config.set_value("Jardinero", "plantas_en_juego", lista_plantas_puras) # Guardamos la lista pura

	var error = config.save(ruta_base)
	if error == OK:
		print("¡Nivel y lista de Jardinero guardados!: ", ruta_base)
	else:
		print("Error al guardar: ", error)

func cargar_estado_de_nivel():
	var texto_sector = "sector_" + str(numero_de_sector)
	var texto_nivel = "Nivel_" + str(numero_de_nivel)
	var ruta_base = "res://niveles/niveles/" + texto_sector + "/" + texto_nivel + ".cfg"
	
	var config = ConfigFile.new()
	var error = config.load(ruta_base)
	
	if error == OK:
		var datos_guardados = config.get_value("Tablero", "datos_celdas", {})
		jardin.tablero.cargar_grilla_desde_cfg(datos_guardados)
		
		var plantas_guardadas = config.get_value("Jardinero", "plantas_en_juego", [])
		jardin.jardinero.plantas_en_tablero.clear()
		
		for datos in plantas_guardadas:
			var nueva_planta: Planta = PLANTA.instantiate()
			
			nueva_planta.key_planta = datos["key_planta"]
			nueva_planta.id_planta = datos["id_planta"]
			nueva_planta.key_estructura = datos["key_estructura"]
			nueva_planta.estructura = datos["estructura"]
			nueva_planta.giro_actual = datos["giro_actual"]
			nueva_planta.ejemplar = datos["ejemplar"]
			nueva_planta.coordenada_celda = datos["coordenada_celda"] 
			
			nueva_planta.scale *= jardin.jardinero.scale
			
			dibujar_planta_cargada(
				nueva_planta.coordenada_celda, 
				nueva_planta.ejemplar, 
				nueva_planta.id_planta, 
				nueva_planta.giro_actual,
			)
			nueva_planta.girar_planta()
			jardin.jardinero.plantas_en_tablero.append(nueva_planta)
			var indice_boton = nueva_planta.id_planta - 1
			var contenedor_botones = ui.catalogo_plantas.contenedor_plantas
			if indice_boton >= 0 and indice_boton < contenedor_botones.get_child_count():
				var boton_original = contenedor_botones.get_child(indice_boton)
				nueva_planta.eliminando.connect(boton_original.mostrar_imagen)
				boton_original.hide()
			
		print("¡Nivel cargado con éxito! Lista del Jardinero restaurada.")
		jardin.naturaleza.analizar_jardin()
	else:
		print("No se encontró el archivo .cfg. Cargando grilla por defecto.")
		jardin.tablero.cargar_grilla_desde_cfg({})

func dibujar_planta_cargada(celda: Vector2i, texto_ejemplar: String, id_planta: int, giro_actual: int):
	var partes = texto_ejemplar.split(":")
	var nombre_planta = partes[0]
	var forma = partes[1]
	var atlas: int
	if forma == "A":
		atlas = Dios.bd_interna["plantas"][nombre_planta]["atlas_A"]
	else:
		atlas = Dios.bd_interna["plantas"][nombre_planta]["atlas_B"]
		
	jardin.jardinero.capa_plantas.set_cell(celda, 0, Vector2i(0, 0), atlas)
	
	await get_tree().process_frame
	
	var posicion_esperada = jardin.jardinero.capa_plantas.map_to_local(celda)
	var planta_correcta: Node = null
	
	for hijo in jardin.jardinero.capa_plantas.get_children():
		if hijo.position.distance_to(posicion_esperada) < 0.5:
			planta_correcta = hijo
			break
	
	if planta_correcta != null:
		if planta_correcta.has_method("configurar"):
			print("Configurando planta ID: ", id_planta, " en celda: ", celda, " con giro: ", giro_actual)
			planta_correcta.configurar(id_planta, giro_actual)
	else:
		print("No se encontró ningún nodo hijo en la celda: ", celda)

func _configurar_planta_cargada(id_a_poner, giro_a_poner):
	var hijos = jardin.jardinero.capa_plantas.get_children()
	if hijos.size() > 0:
		var ultima_planta = hijos[-1]
		if ultima_planta.has_method("configurar"):
			ultima_planta.configurar(id_a_poner, giro_a_poner)
