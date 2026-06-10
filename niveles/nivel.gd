extends Node2D
class_name NivelJugable

signal animacion_iniciada(jugado:bool)

@export var numero_de_nivel:int
@export var numero_de_sector: int
@export var jardin:Jardin
@export var editando:bool = false
@onready var caja_herramienta_ui: Control = $caja_herramienta_ui
var jugado:bool = false

var label_mouse: Label
var panel_mouse: PanelContainer

var sector = "seccion_"+str(numero_de_sector)
var nivel = "nivel_"+str(numero_de_nivel)
const UI_EDICION = preload("uid://la1ktrp08bfg")

var Especie_mariposa:Array

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
@export_enum(
	"objeto_a",
	"objeto_b",
	"objeto_c",
	"objeto_d",
	) var tipos_objeto:Array[String]

@export var datos_de_libro:Array[Recompensa]
const PLANTA = preload("uid://der8d61kw3xr8")
const OBJETO_MOVIL = preload("uid://csae5pte6k7x6")

@onready var ui: Interfas = $UI
@onready var pasar_de_nivel: Timer = $PasarDeNivel
@onready var area_de_juego: Area2D = $AreaDeJuego

var estrellas:int
var puntos_maximos:int

func _input(event: InputEvent) -> void: # esto es re violento aca... jaja TA MAL
	var posicion_mouse_local = jardin.tablero.get_local_mouse_position()
	var casillero_tablero: Vector2i = jardin.tablero.local_to_map(posicion_mouse_local)
	var nombre_planta = jardin.tablero.get_nombre_planta(casillero_tablero)
	
	#jardin.tablero.determinar_interior_exterior_de_grilla(casillero_tablero)
	if panel_mouse:
		panel_mouse.global_position = get_global_mouse_position() + Vector2(15, 15)

		if nombre_planta != "":
			label_mouse.text = nombre_planta
			panel_mouse.show()
		else:
			panel_mouse.hide()
func _ready() -> void:
	evaluar_si_nivel_fue_jugado()
	traer_lista_mariposas()
	definir_etiqueta_del_mause()
	ordenar_mariposas_segun_importancia()
	jardin.naturaleza.generar_mariposas(Especie_mariposa)
	sistema_debug()
	cambiar_entre_ui_edicion_y_juego()
	if !editando: aplicar_apariencia_ganado()
	asignar_señales()
	iniciar_animacion_nivel(jugado)

func iniciar_animacion_nivel(jugado):
	if !editando:
		emit_signal("animacion_iniciada",jugado)
	else:
		emit_signal("animacion_iniciada",true)

func evaluar_si_nivel_fue_jugado():
	var seccion_actual:String = "seccion_"+str(numero_de_sector)
	var nivel_actual:String = "nivel_"+str(numero_de_nivel)
	var dato_de_nivel_jugado = Dios.bd_externa["sectores"][seccion_actual]["niveles"][nivel_actual]["ya_fue_jugado"]
	if dato_de_nivel_jugado:
		jugado = true
		return
	Dios.bd_externa["sectores"][seccion_actual]["niveles"][nivel_actual]["ya_fue_jugado"] = true
	Dios.guardar_bd_externa()
func traer_lista_mariposas():
	var seccion_actual:String = "seccion_"+str(numero_de_sector)
	var nivel_actual:String = "nivel_"+str(numero_de_nivel)
	var lista_mariposas = Dios.bd_interna["sectores"][seccion_actual]["niveles"][nivel_actual]["mariposas"]
	Especie_mariposa = lista_mariposas
func asignar_señales():
	jardin.jardinero.guardar_nivel.connect(guardar_estado_actual)
	jardin.tablero.en_area_de_juego.connect(jardin.jardinero.entrar_en_area_de_juego)
	jardin.tablero.fuera_de_area.connect(jardin.jardinero.salir_del_area_de_juego)
	jardin.tablero.tablero_creado.connect(jardin.establecer_columnas)
	area_de_juego.mouse_entered.connect(jardin.jardinero.entrar_en_area_de_juego)
	area_de_juego.mouse_entered.connect(jardin.jardinero.salir_del_area_de_juego)
func ordenar_mariposas_segun_importancia():
	var orden_importancia = Dios.bd_interna["orden_inportancia_mariposas"]
	var especies_ordenadas: Array[String] = []

	for nombre_mariposa in orden_importancia:
		if Especie_mariposa.has(nombre_mariposa):
			especies_ordenadas.append(nombre_mariposa)

	Especie_mariposa = especies_ordenadas
func definir_etiqueta_del_mause():
	panel_mouse = PanelContainer.new()
	panel_mouse.z_index = 5
	label_mouse = Label.new()
	panel_mouse.add_child(label_mouse)
	add_child(panel_mouse)

	panel_mouse.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label_mouse.mouse_filter = Control.MOUSE_FILTER_IGNORE
func cambiar_entre_ui_edicion_y_juego():
	if editando:
		printerr("Catalogo edicion (objetos movibles NO PLANTAS)")
		var ui_de_edicion:Interfas_herramienta = UI_EDICION.instantiate()
		caja_herramienta_ui.add_child(ui_de_edicion)
		area_de_juego.position = ui_de_edicion.posicion_tablero.position
		area_de_juego.scale *= 0.85
		jardin.tablero._generar_grilla()
		jardin.jardinero.logica_objetos = false
		ui.hide()
		
		ui_de_edicion.objetos_swichearon.connect(activar_swicheo_objeto)
		ui_de_edicion.reiniciar.connect(reiniciar_nivel)
		
		ui_de_edicion.catalogo_plantas.iniciar_catalogo(Especie_planta, jardin)
		ui_de_edicion.catalogo_objetos.iniciar_catalogo(tipos_objeto, jardin)
		ui_de_edicion.catalogo_mariposas.iniciar_catalogo(Especie_mariposa)
		ui_de_edicion.control.cargar_cfg.pressed.connect(cargar_estado_de_nivel)
		ui_de_edicion.control.generar_cfg.pressed.connect(guardar_estado_de_nivel)
	else:
		ui.show()
		#ui_edicion.hide()
		ui.catalogo_plantas.iniciar_catalogo(Especie_planta, jardin)
		ui.catalogo_mariposas.iniciar_catalogo(Especie_mariposa)
		cargar_estado_de_nivel()
		#ui.control.hide()
func activar_swicheo_objeto(prendido:bool):
	jardin.jardinero.swichear_funcion_de_objeto(prendido)
func aplicar_apariencia_ganado():
	var fue_superado = Dios.bd_externa["sectores"]["seccion_"+str(numero_de_sector)]["niveles"]["nivel_"+str(numero_de_nivel)]["superado"]
	#print("GANADO: ",fue_superado)
	ui.prender_estrella(fue_superado)

func sumar_puntos():
	var mariposas_jugadas:Array[Mariposa] = jardin.naturaleza.mariposas_en_juego.duplicate()
	ui.catalogo_mariposas.marcar_mariposas(mariposas_jugadas)
	if Especie_mariposa.size() == mariposas_jugadas.size() and !editando:
		var s_id = "seccion_" + str(numero_de_sector)
		var nivel_id = "nivel_" + str(numero_de_nivel)
		var estado_nivel = Dios.bd_externa["sectores"][s_id]["niveles"][nivel_id]["superado"]
		ui.anim_win()
		if !estado_nivel:
			ui.superar_nivel()
			completar_nivel()
			revelar_datos()
func completar_nivel():
	var sector_id = "seccion_" + str(numero_de_sector)
	var nivel_id = "nivel_" + str(numero_de_nivel)
	Dios.bd_externa["sectores"][sector_id]["niveles"][nivel_id]["superado"] = true
	Dios.bd_externa["sectores"][sector_id]["niveles_superados"] += 1
	Dios.guardar_bd_externa()

func revelar_datos():
	var sector_id = "seccion_" + str(numero_de_sector)
	var nivel_id = "nivel_" + str(numero_de_nivel)
	var nivel_interno = Dios.bd_interna["sectores"][sector_id]["niveles"][nivel_id]
	if nivel_interno.has("mariposas"):
		var lista_mariposas_nivel: Array = nivel_interno["mariposas"]
		for mariposa_id in lista_mariposas_nivel:
			Dios.otorgar_progreso_mariposa(mariposa_id)
			
	Dios.guardar_bd_externa()
func in_superar_nivel():
	var sector_id = "seccion_" + str(numero_de_sector)
	var nivel_id = "nivel_" + str(numero_de_nivel)
	Dios.bd_externa["sectores"][sector_id]["niveles"][nivel_id]["superado"] = false
	Dios.bd_externa["sectores"][sector_id]["niveles_superados"] -= 1 
	Dios.guardar_bd_externa()

func volver_al_Menu():
	get_tree().change_scene_to_file(ui.SELECTOR_NIVELES)
func sistema_debug(): 
	ui.botones_debug.nivel_jugandose = self

func guardar_estado_de_tablero(tablero):
	Dios.bd_externa["sectores"][sector][nivel]["momento_de_juego"] = tablero
	Dios.guardar_bd_externa()
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
	var lista_objetos_puros = []
	var plantas_vivas = jardin.jardinero.plantas_en_tablero.duplicate()
	var objetos_vivos = jardin.jardinero.objetos_en_tablero.duplicate()

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

	for objeto:ObjetosMoviles in objetos_vivos:
		var datos_objeto = {
			"key_objeto": objeto.key_objeto,
			"id_objeto": objeto.id_objeto,
			#"key_estructura":objeto.key_estructura,
			"estructura": objeto.estructura,
			"giro_actual": objeto.giro_actual,
			"coordenada_celda": objeto.coordenada_celda
		}
		lista_objetos_puros.append(datos_objeto)

	var config = ConfigFile.new()
	config.set_value("Tablero", "datos_celdas", diccionario_limpio)
	config.set_value("Jardinero", "plantas_en_juego", lista_plantas_puras)
	config.set_value("Jardinero", "datos_objeto", lista_objetos_puros)

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
func cargar_estado_de_nivel(reinicio:bool = false):
	limpiar_jardin()
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
		var objetos_guardadas = config.get_value("Jardinero", "datos_objeto", [])
		jardin.jardinero.plantas_en_tablero.clear()
		jardin.jardinero.objetos_en_tablero.clear()

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
####3
		for datos_obj in objetos_guardadas:
			var nuevo_objeto: ObjetosMoviles = OBJETO_MOVIL.instantiate() 
			nuevo_objeto.key_objeto = datos_obj["key_objeto"]
			nuevo_objeto.id_objeto = datos_obj["id_objeto"]
			#nuevo_objeto.key_estructura = datos_obj["key_estructura"]
			nuevo_objeto.estructura = datos_obj["estructura"]
			nuevo_objeto.giro_actual = datos_obj["giro_actual"]
			nuevo_objeto.coordenada_celda = datos_obj["coordenada_celda"]
			nuevo_objeto.scale *= jardin.jardinero.scale
			dibujar_objeto_cargado(nuevo_objeto) 
			jardin.jardinero.objetos_en_tablero.append(nuevo_objeto)

		print("Nivel cargado.")
		jardin.naturaleza.analizar_jardin()
	else:
		print("No se encontró el archivo .cfg")
		jardin.tablero.cargar_grilla_desde_cfg({})

func limpiar_jardin():
	for planta in jardin.find_children("*","Planta",true,false):
		planta.queue_free()
	for objeto in jardin.find_children("*","ObjetosMoviles",true,false):
		objeto.queue_free()

func dibujar_planta_cargada(planta:Planta):
	jardin.add_child(planta)
	planta.estructurar_planta()
	planta.giro_de_planta()
	jardin.jardinero.posicionar_planta(planta)
	await get_tree().process_frame
func dibujar_objeto_cargado(objeto: ObjetosMoviles):
	jardin.add_child(objeto)
	objeto.estructurar_objeto()
	objeto.giro_de_objeto()
	jardin.jardinero.posicionar_objeto_en_capa_visible(objeto)
	await get_tree().process_frame
	
