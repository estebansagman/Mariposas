extends Node2D # CADA REGION VA A SER LLEVADO A UN NUEVO SUB_OBJETO
class_name ControlTablero

signal guardar_nivel
signal cambio_en_jardin
signal mariposa_desplazada
signal mariposa_movida(mariposa:Mariposa, parcela:Vector2i)
signal planta_agarrada
signal mariposa_agarrada
signal planta_en_tablero

@export var tablero: Tablero
var planta_seleccionada:Planta
var objeto_seleccionado:ObjetosMoviles
var plantas_en_tablero:Array[Planta]
var objetos_en_tablero:Array[ObjetosMoviles]
var mariposa_seleccionada:Mariposa
var mariposa_en_seleccion:bool = false
@onready var padre:Node2D = $".."
@onready var capa_plantas: TileMapLayer = $"../capa_plantas"
@export var jardin: Node2D

@export var animacion = 0


var en_area_de_juego = false
var destino_planta:Vector2i = Vector2i(-1,0)

var focuseable:bool = false
var lista_focus:Array[Vector2i]
var celda_focus_coordenada:Vector2
var celda_actual:Vector2i
var celda_anterior:Vector2i
var estructura_base:Array[Vector2i]
var logica_objetos:bool = true 

const TIERRA_VFX = preload("uid://cus2tjoueqkvn")
const VFX_HOJAS = preload("uid://m7pacymior17")

func _ready() -> void:
	var UI = get_tree().current_scene.find_child("UI",true,false)
	cambio_en_jardin.connect(UI.ocultar_cartel)

func _input(event: InputEvent) -> void:
	girar_planta(event)
	girar_objeto(event)
func _process(delta: float) -> void:
	var mouse_local = tablero.get_local_mouse_position()
	celda_actual = tablero.local_to_map(mouse_local)
	if celda_actual != celda_anterior:
		tablero.determinar_interior_exterior_de_grilla(celda_actual)
	#if en_area_de_juego and celda_actual != celda_anterior: 
		#tablero.leer_celda(celda_actual)
	celda_anterior = celda_actual
	
	if celda_actual in tablero.celdas:
		var pos_relativa = tablero.map_to_local(celda_actual)
		celda_focus_coordenada = tablero.global_position + pos_relativa

	if planta_seleccionada and celda_actual in tablero.celdas:
		calcular_foco(celda_actual)
	if objeto_seleccionado and celda_actual in tablero.celdas:
		calcular_foco(celda_actual)
	if mariposa_seleccionada and celda_actual in tablero.celdas and mariposa_en_seleccion:
		calcular_foco(celda_actual)

	if mariposa_seleccionada == null:
		mover_planta_seleccionada(celda_actual)
	if mariposa_seleccionada == null:
		mover_objeto_seleccionado(celda_actual)
	mover_mariposa_seleccionada()
	tablero.pintar_lienzo()

func entrar_en_area_de_juego():
	en_area_de_juego = true
	#print(en_area_de_juego)
func salir_del_area_de_juego():
	en_area_de_juego = false
	#print(en_area_de_juego)
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
	elif objeto_seleccionado: estructura_base = objeto_seleccionado.get_estructura()
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
func _limpiar_rastro_tablero(id_objetivo,clase):
	if clase is ObjetosMoviles:
		limpiar_objeto(id_objetivo)
	elif clase is Planta:
		limpiar_planta(id_objetivo)
		
func limpiar_objeto(id_objetivo):
	for celda in tablero.celdas:
		#var no_es_planta = tablero.get_id_planta(celda) < 1
		if tablero.get_id_objeto(celda) == id_objetivo:
			tablero.vaciar_celda(celda)
			capa_plantas.set_cell(celda, -1)
			
			for hijo in capa_plantas.get_children():
				if capa_plantas.local_to_map(hijo.position) == celda:
					hijo.free()

func limpiar_planta(id_objetivo):
	for celda in tablero.celdas:
		if tablero.get_id_planta(celda) == id_objetivo:
			tablero.vaciar_celda(celda)
			capa_plantas.set_cell(celda, -1)
			
			for hijo in capa_plantas.get_children():
				if capa_plantas.local_to_map(hijo.position) == celda:
					hijo.free()
#endregion

#region ACCIONES OBJETO
func seleccionar_objeto(objeto:ObjetosMoviles):
	objeto_seleccionado = objeto
	objeto_seleccionado.z_index = objeto_seleccionado.ZINDEX_SELECCION
	for celda in tablero.celdas:
		var coincide_el_id_en_tablero = tablero.get_id_objeto(celda)==objeto_seleccionado.get_id_objeto()
		#var no_es_planta = tablero.get_id_planta(celda) < 1
		if coincide_el_id_en_tablero:
			tablero.vaciar_celda(celda)
	#activar_particulas(VFX_HOJAS,get_global_mouse_position())
func mover_objeto_seleccionado(celda_actual) -> void:
	#printerr("MOVER PLANTA")
	if Input.is_action_just_pressed("aceptar") and en_area_de_juego:
		if objeto_seleccionado != null: 
			return

		var id_click = tablero.get_id_objeto(celda_actual)
		if id_click != 0:
			for objeto in objetos_en_tablero:
				if objeto.id_objeto == id_click:
					objeto_seleccionado = objeto
					break

			if objeto_seleccionado:
				#printerr("SELECCIONAR PLANTA GRILLA")
				#activar_particulas(VFX_HOJAS,planta_seleccionada.global_position)
				objetos_en_tablero.erase(objeto_seleccionado)
				jardin.add_child(objeto_seleccionado)
				#objeto_seleccionado.estructurar_objeto()
				objeto_seleccionado.z_index = objeto_seleccionado.ZINDEX_SELECCION
				#print("EL GIRO POSTA ESSS: ",objeto_seleccionado.giro_actual)
				_limpiar_rastro_tablero(id_click,objeto_seleccionado)
				emit_signal("cambio_en_jardin")

	if objeto_seleccionado:
		objeto_seleccionado.position = jardin.get_local_mouse_position()
		objeto_seleccionado.show()
		var objeto_soltado = Input.is_action_just_released("aceptar")
		if objeto_soltado:
			decidir_que_hace_el_objeto_al_soltar()
			emit_signal("guardar_nivel")

func decidir_que_hace_el_objeto_al_soltar():
	var puede_ir_en_nueva_posicion:bool = focuseable and en_area_de_juego
	if puede_ir_en_nueva_posicion:
		posicionar_objeto_en_tablero()
		#emit_signal("cambio_en_jardin")
	elif logica_objetos:
		#emit_signal("cambio_en_jardin")
		devolver_a_su_lugar_anterior()
	else:
		devolver_a_la_caja_de_objetos()
func devolver_a_la_caja_de_objetos():
	objeto_seleccionado.activar_boton()
	objeto_seleccionado.queue_free()
	objeto_seleccionado = null
	limpiar_focos()
func devolver_a_su_lugar_anterior():
	for casilla in objeto_seleccionado.posicion_anterior:
		tablero.ocupar_celda(casilla,null,null, objeto_seleccionado)

	objeto_seleccionado.z_index = objeto_seleccionado.ZINDEX_ORIGEN
	objetos_en_tablero.append(objeto_seleccionado)
	#objeto_seleccionado.coordenada_celda = celda_actual
	posicionar_objeto_en_capa_visible(objeto_seleccionado)
	#activar_particulas(TIERRA_VFX,planta_seleccionada.global_position)
	#var planta_a_fijar = objeto_seleccionado
	objeto_seleccionado = null
	limpiar_focos()
func posicionar_objeto_en_tablero():
	objeto_seleccionado.posicion_anterior.clear()
	for casilla in lista_focus:
		tablero.ocupar_celda(casilla,null,null, objeto_seleccionado)
		objeto_seleccionado.posicion_anterior.append(casilla)

	objeto_seleccionado.z_index = objeto_seleccionado.ZINDEX_ORIGEN
	objetos_en_tablero.append(objeto_seleccionado)
	objeto_seleccionado.coordenada_celda = celda_actual
	
	posicionar_objeto_en_capa_visible(objeto_seleccionado)
	#activar_particulas(TIERRA_VFX,planta_seleccionada.global_position)
	#var planta_a_fijar = objeto_seleccionado
	objeto_seleccionado = null
	limpiar_focos()
	
	await get_tree().process_frame
func posicionar_objeto_en_capa_visible(objeto:ObjetosMoviles):
	if objeto:
		var posicion_en_tablero:Vector2 = capa_plantas.map_to_local(objeto.coordenada_celda)
		print(posicion_en_tablero)
		objeto.position = posicion_en_tablero*scale.x
		#activar_particulas(TIERRA_VFX,planta)
func girar_objeto(event:InputEvent = null):
	if objeto_seleccionado and event:
		if event.is_action_pressed("girar_derecha"):
			objeto_seleccionado.giro_actual = (objeto_seleccionado.giro_actual + 1) % 4
			objeto_seleccionado.girar_objeto(true)
			#objeto_seleccionado.emitir_particulas_giro("derecha")

		elif event.is_action_pressed("girar_izquierda"):
			objeto_seleccionado.giro_actual = (objeto_seleccionado.giro_actual - 1) if objeto_seleccionado.giro_actual > 0 else 3
			objeto_seleccionado.girar_objeto(false)
			#objeto_seleccionado.emitir_particulas_giro("izquierda")
func swichear_funcion_de_objeto(prendido):
	#print("AAAAAAAAAAAAAAAAAAAA")
	logica_objetos = !logica_objetos
#endregion

#region ACCIONES PLANTA
func seleccionar_planta(planta:Planta):
	#printerr("SELECCIONAR PLANTA CATALOGO")
	planta_seleccionada = planta
	planta_seleccionada.z_index = planta_seleccionada.ZINDEX_SELECCION
	for celda in tablero.celdas:
		if tablero.get_id_planta(celda)==planta_seleccionada.get_id_planta():
			tablero.vaciar_celda(celda)
	if animacion == 0:
		emit_signal("planta_agarrada")
		animacion += 1
	activar_particulas(VFX_HOJAS,get_global_mouse_position())
	
func mover_planta_seleccionada(celda_actual) -> void:
	#printerr("MOVER PLANTA")
	if Input.is_action_just_pressed("aceptar") and en_area_de_juego:
		tablero.leer_celda(celda_actual)
		if planta_seleccionada != null: 
			return

		var id_click = tablero.get_id_planta(celda_actual)
		if id_click != 0:
			for planta in plantas_en_tablero:
				if planta.id_planta == id_click:
					planta_seleccionada = planta
					break
			if planta_seleccionada:
				printerr("SELECCIONAR PLANTA GRILLA")
				activar_particulas(VFX_HOJAS,planta_seleccionada.global_position)
				plantas_en_tablero.erase(planta_seleccionada)
				jardin.add_child(planta_seleccionada)
				#planta_seleccionada.estructurar_planta()
				planta_seleccionada.z_index = planta_seleccionada.ZINDEX_SELECCION
				print("EL GIRO POSTA ESSS: ",planta_seleccionada.giro_actual)
				_limpiar_rastro_tablero(id_click,planta_seleccionada)
				emit_signal("cambio_en_jardin")
				
			
	if planta_seleccionada:
		planta_seleccionada.position = jardin.get_local_mouse_position()
		planta_seleccionada.show()

		if Input.is_action_just_released("aceptar"):

			if focuseable and en_area_de_juego:
				for casilla in lista_focus:
					tablero.ocupar_celda(casilla, planta_seleccionada)

				planta_seleccionada.z_index = planta_seleccionada.ZINDEX_ORIGEN
				plantas_en_tablero.append(planta_seleccionada)
				if animacion == 1:
					emit_signal("planta_en_tablero")
					print("paso de animacion : ",animacion)
					animacion += 1
				planta_seleccionada.coordenada_celda = celda_actual
				
				posicionar_planta(planta_seleccionada)
				activar_particulas(TIERRA_VFX,planta_seleccionada.global_position)
				
				var planta_a_fijar = planta_seleccionada
				planta_seleccionada = null
				limpiar_focos()
				
				await get_tree().process_frame
				emit_signal("cambio_en_jardin")
				emit_signal("guardar_nivel")
				
			else:
				emit_signal("cambio_en_jardin")
				emit_signal("guardar_nivel")
				planta_seleccionada.activar_boton()
				planta_seleccionada.queue_free()
				planta_seleccionada = null
				limpiar_focos()
			
func posicionar_planta(planta:Planta):
	if planta:
		var posicion_en_tablero:Vector2 = capa_plantas.map_to_local(planta.coordenada_celda)
		print(posicion_en_tablero)
		planta.position = posicion_en_tablero*scale.x
		#activar_particulas(TIERRA_VFX,planta)
func girar_planta(event:InputEvent = null):
	if planta_seleccionada and event:
		if event.is_action_pressed("girar_derecha"):
			planta_seleccionada.giro_actual = (planta_seleccionada.giro_actual + 1) % 4
			planta_seleccionada.girar_planta(true)
			planta_seleccionada.emitir_particulas_giro("derecha")

		elif event.is_action_pressed("girar_izquierda"):
			planta_seleccionada.giro_actual = (planta_seleccionada.giro_actual - 1) if planta_seleccionada.giro_actual > 0 else 3
			planta_seleccionada.girar_planta(false)
			planta_seleccionada.emitir_particulas_giro("izquierda")
#endregion

#region ACCIONES MARIPOSA
func seleccionar_mariposa(mariposa:Mariposa):
	if mariposa_seleccionada == null and planta_seleccionada == null:
		mariposa_seleccionada = mariposa
		print("mariposa seleccionada")
		#if animacion == 
		
func soltar_mariposa():
	if !mariposa_en_seleccion:
		mariposa_seleccionada = null
func generarl_lista_requerimientos()->Array[String]:
	var lista_de_requerimientos:Array[String]
	for celda in lista_focus:
		if tablero.celdas.has(celda): 
			lista_de_requerimientos.append(tablero.get_tipo(celda))
		else:
			lista_de_requerimientos.clear()
			lista_de_requerimientos.append("")
			return lista_de_requerimientos

	for celda in lista_focus:
		#if tablero.celdas[celda][tablero.tipo_casilla_key] == tablero.casilla_bloqueo:
			#lista_de_requerimientos.clear()
			#lista_de_requerimientos.append("")
		if tablero.celdas[celda][tablero.mariposa]:
			lista_de_requerimientos.clear()
			return [""]
	
	return lista_de_requerimientos
func mover_mariposa_seleccionada()->void:
	if mariposa_seleccionada:
		if Input.is_action_just_pressed("aceptar"):
			mariposa_en_seleccion = true
			mariposa_seleccionada.display_agarrada()
			var posicion_actual = mariposa_seleccionada.posicion_jardin.duplicate()
			for parcela in posicion_actual: 
				tablero.sacar_mariposa(parcela)
			if animacion == 0:
				animacion += 1
				emit_signal("mariposa_agarrada")
		if mariposa_en_seleccion: 
			mariposa_seleccionada.position = get_global_mouse_position()

		if Input.is_action_just_released("aceptar") and en_area_de_juego and mariposa_seleccionada.confirmar_requerimientos(generarl_lista_requerimientos()):
			mariposa_seleccionada.apagar()
			mariposa_seleccionada.animation_player.play()
			mariposa_seleccionada.animation_player.stop()
			#mariposa_seleccionada.animar_spawn(mariposa_seleccionada, parcela, capa_mariposas.to_global(capa_mariposas.map_to_local(parcela)))
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
			emit_signal("cambio_en_jardin")

		elif Input.is_action_just_released("aceptar")and mariposa_en_seleccion:
			mariposa_seleccionada.animation_player.play()
			mariposa_seleccionada.animation_player.stop()
			mariposa_seleccionada.posicion_jardin = []
			emit_signal("cambio_en_jardin")
			lista_focus.clear()
			mariposa_seleccionada.apagar()
			mariposa_en_seleccion = false
			mariposa_seleccionada = null
			limpiar_focos()
func _iluminar_mariposa():
	if mariposa_seleccionada and mariposa_en_seleccion:
		mariposa_seleccionada.iluminar(mariposa_seleccionada.confirmar_requerimientos(generarl_lista_requerimientos()))
#endregion

func activar_particulas(particulas,posicion:Vector2)->void:
	var vfx:GPUParticles2D = particulas.duplicate().instantiate()
	add_child(vfx,true)
	#printerr(vfx)
	vfx.global_position = posicion
	vfx.emitting = true
	await vfx.finished
	vfx.queue_free()
