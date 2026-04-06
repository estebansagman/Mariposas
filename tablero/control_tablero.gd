extends Node2D # CADA REGION VA A SER LLEVADO A UN NUEVO SUB_OBJETO
class_name ControlTablero

signal cambio_en_jardin
signal mariposa_desplazada
signal mariposa_movida(mariposa:Mariposa, parcela:Vector2i)


@export var tablero: Tablero
var planta_seleccionada:Planta
var plantas_en_tablero:Array[Planta]
var mariposa_seleccionada:Mariposa
var mariposa_en_seleccion:bool = false
@onready var padre:Node2D = $".."
@onready var capa_plantas: TileMapLayer = $"../Jardin/capa_plantas"
@export var jardin: Node2D

var en_area_de_juego = false
var destino_planta:Vector2i = Vector2i(-1,0)

var focuseable:bool = false
var lista_focus:Array[Vector2i]
var celda_focus_coordenada:Vector2
var celda_actual:Vector2i
var estructura_base:Array[Vector2i]

func _input(event: InputEvent) -> void:
	girar_mariposa(event)

func _process(delta: float) -> void:
	var mouse_local = tablero.get_local_mouse_position()
	celda_actual = tablero.local_to_map(mouse_local)
	if celda_actual in tablero.celdas:
		var pos_relativa = tablero.map_to_local(celda_actual)
		celda_focus_coordenada = tablero.global_position + pos_relativa

	mover_planta_seleccionada(celda_actual)
	mover_mariposa_seleccionada()

	if planta_seleccionada and celda_actual in tablero.celdas:
		calcular_foco(celda_actual)
	if mariposa_seleccionada and celda_actual in tablero.celdas:
		calcular_foco(celda_actual)
	tablero.pintar_lienzo()

func entrar_en_area_de_juego():
	en_area_de_juego = true
	print(en_area_de_juego)
func salir_del_area_de_juego():
	en_area_de_juego = false
	print(en_area_de_juego)
	limpiar_focos()
	if mariposa_en_seleccion:
		_iluminar_mariposa()

func limpiar_focos():
	for celda in tablero.celdas:
		tablero.soltar_foco(celda)

#region ACCIONES TABLERO
func calcular_foco(celda_mouse):
	generar_focos()
	_iluminar_mariposa()
	if planta_seleccionada: estructura_base = planta_seleccionada.get_estructura()
	elif mariposa_seleccionada: estructura_base = mariposa_seleccionada.get_estructura()
	focuseable = true
	lista_focus.clear()
	for modulo in estructura_base:
		lista_focus.append(modulo+celda_mouse)
	#print(lista_focus)
	for modulo in lista_focus:
		if modulo in tablero.celdas and !tablero.get_ocupacion_de_celda(modulo):
			tablero.focusear(modulo) # me parece que esto quedo HACIENDO NADA
		else: 
			focuseable = false
			generar_focos()
			break
func generar_focos():
	for celda in tablero.celdas:
		if celda in lista_focus and focuseable and !tablero.get_ocupacion_de_celda(celda):
			tablero.focusear(celda)
		else:
			tablero.soltar_foco(celda)
func _limpiar_rastro_tablero(id_target):
	for celda in tablero.celdas:
		if tablero.get_id_planta(celda) == id_target:
			tablero.vaciar_celda(celda)
			capa_plantas.set_cell(celda, -1)
#endregion

#region ACCIONES PLANTA
func seleccionar_planta(planta:Planta):
	planta_seleccionada = planta
	for celda in tablero.celdas:
		if tablero.get_id_planta(celda)==planta_seleccionada.get_id_planta():
			tablero.vaciar_celda(celda)

func mover_planta_seleccionada(celda_actual) -> void:
	if Input.is_action_just_pressed("aceptar") and en_area_de_juego:
		tablero.leer_celda(celda_actual)

		if tablero.celdas.has(celda_actual):
			if tablero.celdas[celda_actual][tablero.mariposa] == true: return

		var id_click = tablero.get_id_planta(celda_actual)
		if id_click != 0:
			for planta in plantas_en_tablero:
				if planta.id_planta == id_click:
					planta_seleccionada = planta
					break
			if planta_seleccionada:
				plantas_en_tablero.erase(planta_seleccionada)
				jardin.add_child(planta_seleccionada)
				_limpiar_rastro_tablero(id_click)
				emit_signal("cambio_en_jardin")

	if planta_seleccionada:
		planta_seleccionada.position = jardin.get_local_mouse_position()
		planta_seleccionada.show()

		if Input.is_action_just_released("aceptar"):
			if focuseable and en_area_de_juego:
				for casilla in lista_focus:
					tablero.ocupar_celda(casilla, planta_seleccionada)
					capa_plantas.set_cell(casilla, 2, Vector2i(0,planta_seleccionada.datos.tipo_de_planta))
				plantas_en_tablero.append(planta_seleccionada)
				planta_seleccionada.get_parent().remove_child(planta_seleccionada)
				emit_signal("cambio_en_jardin")
			else:
				emit_signal("cambio_en_jardin")
				planta_seleccionada.activar_boton()
				planta_seleccionada.queue_free()

			planta_seleccionada = null
			limpiar_focos()

func posicionar_planta():
	if planta_seleccionada:
		planta_seleccionada.position = celda_focus_coordenada
#endregion

#region ACCIONES MARIPOSA
func seleccionar_mariposa(mariposa:Mariposa):
	if mariposa_seleccionada == null:
		mariposa_seleccionada = mariposa

func soltar_mariposa():
	if !mariposa_en_seleccion:
		mariposa_seleccionada = null

func generarl_lista_requerimientos()->Array[Dios.Especie]:
	var lista_de_requerimientos:Array[Dios.Especie]
	for celda in lista_focus:
		if tablero.celdas.has(celda): 
			lista_de_requerimientos.append(tablero.get_tipo(celda))
		else:
			lista_de_requerimientos.clear()
			lista_de_requerimientos.append(-1)
			return lista_de_requerimientos

	for celda in lista_focus:
		if tablero.celdas[celda][tablero.tipo_casilla_key] == tablero.casilla_bloqueo:
			lista_de_requerimientos.clear()
			lista_de_requerimientos.append(-1)
		if tablero.celdas[celda][tablero.mariposa]:
			lista_de_requerimientos.clear()
			return [-1]
	return lista_de_requerimientos

func mover_mariposa_seleccionada()->void:
	if mariposa_seleccionada:
		if Input.is_action_just_pressed("aceptar"):
			mariposa_en_seleccion = true
			var posicion_actual = mariposa_seleccionada.posicion_jardin.duplicate()
			for parcela in posicion_actual: 
				tablero.sacar_mariposa(parcela)
		if mariposa_en_seleccion: 
			mariposa_seleccionada.position = get_global_mouse_position()

		if Input.is_action_just_released("aceptar") and en_area_de_juego and mariposa_seleccionada.confirmar_requerimientos(generarl_lista_requerimientos()):
			for casilla in lista_focus:
				tablero.celdas[casilla][tablero.mariposa] = true
				tablero.celdas[casilla][tablero.id_mariposa_key] = mariposa_seleccionada.id_mariposa
			mariposa_seleccionada.posicion_jardin = lista_focus.duplicate()
			print(mariposa_seleccionada.posicion_jardin)
			lista_focus.clear()
			mariposa_en_seleccion = false
			emit_signal("mariposa_movida",mariposa_seleccionada,celda_actual)
			mariposa_seleccionada.apagar()
			limpiar_focos()
		elif Input.is_action_just_released("aceptar"):
			mariposa_seleccionada.posicion_jardin = []
			emit_signal("cambio_en_jardin")
			lista_focus.clear()
			mariposa_en_seleccion = false
			mariposa_seleccionada = null
			limpiar_focos()

func girar_mariposa(event:InputEvent = null):
	if planta_seleccionada and event:
		if event.is_action_pressed("girar_derecha"):
			planta_seleccionada.giro_actual = (planta_seleccionada.giro_actual + 1) % 4
			planta_seleccionada.girar_planta()

		elif event.is_action_pressed("girar_izquierda"):
			planta_seleccionada.giro_actual = (planta_seleccionada.giro_actual - 1) if planta_seleccionada.giro_actual > 0 else 3
			planta_seleccionada.girar_planta()

func _iluminar_mariposa():
	if mariposa_seleccionada and mariposa_en_seleccion:
		if mariposa_seleccionada.confirmar_requerimientos(generarl_lista_requerimientos()):
			mariposa_seleccionada.iluminar()
		else: mariposa_seleccionada.apagar()
		if !en_area_de_juego: mariposa_seleccionada.apagar()

#endregion
