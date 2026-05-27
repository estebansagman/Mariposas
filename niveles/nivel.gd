extends Node2D
class_name NivelJugable

@export var numero_de_nivel:int
@export var numero_de_sector: int
@export var jardin:Jardin
@export var editando:bool = false

var label_mouse: Label
var panel_mouse: PanelContainer

var sector = "seccion_"+str(numero_de_sector)
var nivel = "nivel_"+str(numero_de_nivel)

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
const PLANTA = preload("uid://der8d61kw3xr8")

@onready var ui: Interfas = $UI
@onready var pasar_de_nivel: Timer = $PasarDeNivel

var estrellas:int
var puntos_maximos:int

func _input(event: InputEvent) -> void: # esto es re violento aca... jaja TA MAL
	var posicion_mouse_local = jardin.tablero.get_local_mouse_position()
	var casillero_tablero: Vector2i = jardin.tablero.local_to_map(posicion_mouse_local)
	var nombre_planta = jardin.tablero.get_nombre_planta(casillero_tablero)

	if panel_mouse:
		panel_mouse.global_position = get_global_mouse_position() + Vector2(15, 15)

		if nombre_planta != "":
			label_mouse.text = nombre_planta
			panel_mouse.show()
		else:
			panel_mouse.hide()

func _ready() -> void:
	panel_mouse = PanelContainer.new()
	panel_mouse.z_index = 5
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

	if editando:
		jardin.tablero._generar_grilla()
		ui.control.show()
		ui.control.cargar_cfg.pressed.connect(cargar_estado_de_nivel)
		ui.control.generar_cfg.pressed.connect(guardar_estado_de_nivel)
	else :
		cargar_estado_de_nivel()
		ui.control.hide()

func sumar_puntos():
	var mariposas_jugadas:Array[Mariposa] = jardin.naturaleza.mariposas_en_juego.duplicate()
	ui.catalogo_mariposas.marcar_mariposas(mariposas_jugadas)
	if Especie_mariposa.size() == mariposas_jugadas.size():
		var s_id = "seccion_" + str(numero_de_sector)
		var nivel_id = "nivel_" + str(numero_de_nivel)
		var estado_nivel = Dios.bd_externa["sectores"][s_id]["niveles"][nivel_id]["superado"]
		ui.anim_win()
		if !estado_nivel:
			ui.superar_nivel()
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

func guardar_estado_actual():
	if !editando:
		guardar_estado_de_nivel()

func guardar_estado_de_nivel():
	var texto_sector = "sector_" + str(numero_de_sector)
	var texto_nivel = "Nivel_" + str(numero_de_nivel)
	var ruta_base: String

	if editando:
		ruta_base = "res://niveles/niveles/" + texto_sector + "/" + texto_nivel + ".cfg"
	else:
		ruta_base = "user://niveles/niveles/" + texto_sector + "/" + texto_nivel + ".cfg"

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
	config.set_value("Jardinero", "plantas_en_juego", lista_plantas_puras)

	var error = config.save(ruta_base)
	if error == OK:
		print("¡Nivel guardado!: ", ruta_base)
	else:
		print("Error al guardar: ", error)

func reiniciar_nivel():
	if editando:
		get_tree().reload_current_scene()
	else:
		
		var contenedor_botones = ui.catalogo_plantas.contenedor_plantas
		for i in range(contenedor_botones.get_child_count()):
			var boton = contenedor_botones.get_child(i)
			boton.show()
			if boton.has_method("mostrar_imagen"):
				boton.mostrar_imagen()
		limpiar_jardin()
		#jardin.capa_plantas.clear()
		cargar_estado_de_nivel(true)	
		guardar_estado_actual()
func limpiar_jardin():
	for planta in jardin.find_children("*","Planta",true,false):
		planta.queue_free()

func cargar_estado_de_nivel(reinicio:bool = false):
	var texto_sector = "sector_" + str(numero_de_sector)
	var texto_nivel = "Nivel_" + str(numero_de_nivel)
	var ruta_base
	if editando or reinicio:
		ruta_base = "res://niveles/niveles/" + texto_sector + "/" + texto_nivel + ".cfg"
	else:
		ruta_base = "user://niveles/niveles/" + texto_sector + "/" + texto_nivel + ".cfg"
	
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
			
			dibujar_planta_cargada(nueva_planta)
			
			jardin.jardinero.plantas_en_tablero.append(nueva_planta)
			
			var indice_boton = nueva_planta.id_planta - 1
			var contenedor_botones = ui.catalogo_plantas.contenedor_plantas
			if indice_boton >= 0 and indice_boton < contenedor_botones.get_child_count():
				var boton_original = contenedor_botones.get_child(indice_boton)
				nueva_planta.eliminando.connect(boton_original.mostrar_imagen)
				boton_original.hide()
			
		print("Nivel cargado.")
		jardin.naturaleza.analizar_jardin()
	else:
		print("No se encontró el archivo .cfg")
		jardin.tablero.cargar_grilla_desde_cfg({})

func dibujar_planta_cargada(planta:Planta):
	jardin.add_child(planta)
	planta.estructurar_planta()
	planta.girar_planta()
	jardin.jardinero.posicionar_planta(planta)
	await get_tree().process_frame
