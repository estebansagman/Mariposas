extends Node2D
class_name Naturaleza
signal mariposa_cambio

@onready var mariposa_escena = preload("uid://dprfbi2712evq")

@export var jardin: Node2D
@export var jardinero:ControlTablero

@onready var mariposas_objeto:Array[Mariposa]
@onready var mariposas_en_juego:Array[Mariposa]
@onready var tablero: Tablero = $"../Tablero"
@onready var capa_plantas: TileMapLayer = $"../capa_plantas"
@onready var capa_mariposas: TileMapLayer = $"../capa_mariposas"

var mariposas:Array[String]


func generar_mariposas(datos:Array[String]):
	mariposas = datos.duplicate()
	print("generando")
	for mariposa in mariposas:
		var mariposa_objeto:Mariposa = mariposa_escena.instantiate()# OK
		mariposa_objeto.key_mariposa = mariposa
		mariposa_objeto.id_mariposa = mariposas_objeto.size()+1
		mariposa_objeto.enfocada.connect(jardinero.seleccionar_mariposa)
		mariposa_objeto.fuera_de_foco.connect(jardinero.soltar_mariposa)
		mariposas_objeto.append(mariposa_objeto)


#region
func analizar_jardin() -> void:
	_limpiar_mariposas_viejas()

	for mariposa in mariposas_objeto:
		if mariposa in mariposas_en_juego: 
			continue
		var cuadrante_encontrado: Array[Vector2i] = _buscar_espacio_para_mariposa(mariposa)
		if not cuadrante_encontrado.is_empty():
			_ubicar_mariposa_en_jardin(mariposa, cuadrante_encontrado)


func _limpiar_mariposas_viejas() -> void:
	if mariposas_en_juego.is_empty(): return
	
	for mariposa in mariposas_en_juego.duplicate():
		var cuadrante_tipo: Array[String] = []
		for parcela in mariposa.posicion_jardin:
			cuadrante_tipo.append(tablero.get_tipo(parcela))
			
		if mariposa.confirmar_requerimientos(cuadrante_tipo):
			continue 
			
		for parcela in mariposa.posicion_jardin:
			tablero.sacar_mariposa(parcela)    
		mariposas_en_juego.erase(mariposa)
		emit_signal("mariposa_cambio")
		if mariposa.get_parent():
			mariposa.get_parent().remove_child(mariposa)

func _buscar_espacio_para_mariposa(mariposa) -> Array[Vector2i]:
	for parcela in tablero.celdas:
		var v1 = parcela + Vector2i(1, 0)
		var v2 = parcela + Vector2i(0, 1)
		var v3 = parcela + Vector2i(1, 1)
		var celdas = tablero.celdas
		
		if not (celdas.has(v1) and celdas.has(v2) and celdas.has(v3)):
			continue
			
		var cuadrante: Array[Vector2i] = [parcela, v1, v2, v3]
		
		if not _es_cuadrante_valido(cuadrante):
			continue
			
		var cuadrante_tipo: Array[String] = []
		for casilla in cuadrante:
			var tipo = tablero.get_tipo(casilla)
			if tipo != "": 
				cuadrante_tipo.append(tipo)
		
		if mariposa.confirmar_requerimientos(cuadrante_tipo):
			return cuadrante
			
	return []

func _es_cuadrante_valido(cuadrante: Array[Vector2i]) -> bool:
	for casilla in cuadrante:
		var tipo_de_suelo: String = tablero.celdas[casilla][tablero.tipo_casilla_key]
		#if tipo_de_suelo == tablero.casilla_bloqueo:
			#return false
			
		var hay_mariposa = tablero.celdas[casilla][tablero.mariposa]
		if hay_mariposa:
			return false
			
	return true

func _ubicar_mariposa_en_jardin(mariposa, cuadrante: Array[Vector2i]) -> void:
	mariposas_en_juego.append(mariposa)
	mariposa.posicion_jardin = cuadrante.duplicate()
	
	_spawnear_mariposa(mariposa, cuadrante[0])
	
	for celda in cuadrante:
		tablero.celdas[celda][tablero.mariposa] = true
		tablero.celdas[celda][tablero.id_mariposa_key] = mariposa.id_mariposa
#endregion

func _spawnear_mariposa(mariposa: Mariposa, parcela: Vector2i):
	emit_signal("mariposa_cambio")
	mariposa.scale = Vector2.ONE
	if mariposa.get_parent() == null:
		jardin.add_child(mariposa)
	mariposa.scale *= scale
	mariposa.scale /= jardin.columnas 
	mariposa.animar_spawn(parcela, capa_mariposas.to_global(capa_mariposas.map_to_local(parcela)))

"""
#func animar_spawn(mariposa: Mariposa, parcela:Vector2i)->void:
#	var modelo:Node3D = mariposa.find_child("Mariposa3D",true)
#	var duration:float = 0.5
	var vueltas:int = 1
	var t = create_tween()
	var pos_global = capa_mariposas.to_global(capa_mariposas.map_to_local(parcela))

	modelo.global_rotation_degrees = Vector3(randf_range(-30,30),randf_range(-90,90),randf_range(-45,45))

	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_BACK)
	modelo.find_child("AnimationPlayer",true).play()
	for vuelta in vueltas:
		t.parallel().tween_property(mariposa,"global_position",Vector2(randf_range(250,750),randf_range(100,600)),duration)
		t.tween_interval(duration)
		t.tween_property(modelo,"global_rotation_degrees",Vector3(randf_range(-30,30),randf_range(-90,90),randf_range(-45,45)),duration)
	
	t.parallel().tween_property(mariposa,"global_position",pos_global,duration)
	t.tween_interval(duration)
	
	t.tween_property(modelo,"global_rotation_degrees",Vector3.ZERO,duration)
	await t.finished
	modelo.find_child("AnimationPlayer",true).stop()
""" 

func actualizar_posicion(mariposa: Mariposa, parcela: Vector2i):
	var pos_global = capa_mariposas.to_global(capa_mariposas.map_to_local(parcela))
	mariposa.global_position = pos_global

func _obtener_cuadrante(celda:Vector2i) -> Array[Vector2i]:
	return [celda,
			Vector2i(celda.x+1,celda.y), 
			Vector2i(celda.x,celda.y+1),
			Vector2i(celda.x+1,celda.y+1)]
