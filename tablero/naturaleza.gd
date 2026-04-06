extends Node2D
class_name Naturaleza


@onready var mariposa_escena = preload("uid://dprfbi2712evq")
@export var mariposas:Array[RecursoMariposa]
@export var Jardinero:ControlTablero

@onready var mariposas_objeto:Array[Mariposa]
@onready var mariposas_en_juego:Array[Mariposa]
@onready var tablero: Tablero = $"../Tablero"
@onready var capa_plantas: TileMapLayer = $"../capa_plantas"
@onready var capa_mariposas: TileMapLayer = $"../capa_mariposas"


func _ready() -> void:
	generar_mariposas()

func generar_mariposas():
	print("generando")
	for mariposa in mariposas:
		var mariposa_objeto:Mariposa = mariposa_escena.instantiate()
		mariposa_objeto.datos = mariposa
		mariposa_objeto.id_mariposa = mariposas_objeto.size()
		mariposa_objeto.enfocada.connect(Jardinero.seleccionar_mariposa)
		mariposa_objeto.fuera_de_foco.connect(Jardinero.soltar_mariposa)
		mariposas_objeto.append(mariposa_objeto)

func analizar_jardin(): # DIVIDIR EN SUBFUNCIONES
	if not mariposas_en_juego.is_empty():
		for mariposa in mariposas_en_juego.duplicate():
			var cuadrante_tipo: Array[Dios.Especie] = []
			
			for parcela in mariposa.posicion_jardin:
				cuadrante_tipo.append(tablero.get_tipo(parcela))
			if mariposa.confirmar_requerimientos(cuadrante_tipo):
				continue 
			
			for parcela in mariposa.posicion_jardin:
				tablero.sacar_mariposa(parcela)	
			mariposas_en_juego.erase(mariposa)

			if mariposa.get_parent():
				mariposa.get_parent().remove_child(mariposa)
		print(mariposas_en_juego)
		
	for parcela in tablero.celdas:
		var v1 = parcela + Vector2i(1, 0)
		var v2 = parcela + Vector2i(0, 1)
		var v3 = parcela + Vector2i(1, 1)
		var cuadrante:Array[Vector2i] = [parcela, v1, v2, v3]
		if not (tablero.celdas.has(v1) and tablero.celdas.has(v2) and tablero.celdas.has(v3)):
			continue
		var es_habitable = true
		for c in cuadrante:
			if tablero.celdas[c][tablero.tipo_casilla_key] == tablero.casilla_bloqueo:
				es_habitable = false
				break
		if not es_habitable:
			continue
		if cuadrante.any(func(v): return tablero.get_existencia_de_mariposas(v)):
			continue
			
		var cuadrante_tipo: Array[Dios.Especie] = []
		for casilla in cuadrante:
			var tipo = tablero.get_tipo(casilla) #Especie, "tipo" es raro, arreglar eso a futuro
			if tipo != -1: cuadrante_tipo.append(tipo)
		for mariposa in mariposas_objeto:
			if mariposa in mariposas_en_juego: continue
			if mariposa.confirmar_requerimientos(cuadrante_tipo):
				mariposas_en_juego.append(mariposa)
				mariposa.posicion_jardin = cuadrante.duplicate()
				print(mariposa.posicion_jardin)
				_spawnear_mariposa(mariposa, parcela)
				#mariposas_en_juego.append(mariposa)
				print(mariposas_en_juego)
				for celda in cuadrante:
					tablero.celdas[celda][tablero.mariposa] = true
					tablero.celdas[celda][tablero.id_mariposa_key] = mariposa.id_mariposa

func _spawnear_mariposa(mariposa: Mariposa, parcela: Vector2i):
	mariposa.scale = Vector2.ONE
	if mariposa.get_parent() == null:
		Jardinero.jardin.add_child(mariposa)
	mariposa.scale *=7.859
	mariposa.scale /= Jardinero.jardin.columnas
	animar_spawn(mariposa,parcela)
	#actualizar_posicion(mariposa, parcela)

func animar_spawn(mariposa: Mariposa, parcela:Vector2i)->void:
	var duration:float = 1.0
	var loops:int = 3
	var t = create_tween()
	var pos_global = capa_mariposas.to_global(capa_mariposas.map_to_local(parcela))
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_BACK)
	aleteo(mariposa,loops)
	for loop in loops:
		#t.parallel().tween_property(mariposa,"skew",deg_to_rad(randfn(-89.9,89.9)),duration)
		t.parallel().tween_property(mariposa,"global_position",Vector2(randf_range(250,750),randf_range(100,600)),duration)
		t.tween_property(mariposa.textura,"skew",deg_to_rad(randfn(-25,25)),duration)
	t.parallel().tween_property(mariposa,"global_position",pos_global,duration)
	t.tween_property(mariposa.textura,"skew",0,duration)

func aleteo(mariposa:Mariposa,loops) -> void:
	for loop in loops*4:
		var a = create_tween()
		a.tween_property(mariposa.textura,"scale",Vector2(0.2,1.0),0.2).set_trans(Tween.TRANS_BOUNCE)
		a.tween_property(mariposa.textura,"scale",Vector2.ONE,0.2).set_trans(Tween.TRANS_BOUNCE)
		await a.finished

func actualizar_posicion(mariposa: Mariposa, parcela: Vector2i):
	var pos_global = capa_mariposas.to_global(capa_mariposas.map_to_local(parcela))
	mariposa.global_position = pos_global
	#mariposa.global_position += Vector2(16, 16)
	
func _obtener_cuadrante(celda:Vector2i) -> Array[Vector2i]:
	return [celda,
			Vector2i(celda.x+1,celda.y),
			Vector2i(celda.x,celda.y+1),
			Vector2i(celda.x+1,celda.y+1)]
