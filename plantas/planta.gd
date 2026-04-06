extends Node2D
class_name Planta
signal soltando  
#signal seleccionado(planta:Planta)
signal en_focus(planta:Planta)
signal eliminando

var id_planta:int = 0 # este id es para saber dentro del tablero que planta es, aunque hayan 2 "iguales", su id es distinto.
var pieza_seleccionada:bool = false
@export var datos:RecursoPlanta
@onready var estructura:Array[Vector2i]
@onready var area_2d: Area2D = $Area2D
var hay_mariposa:bool = false

var focus = true
#var giros_posibles:Array[int] = [0,1,2,3]
var giro_actual:int = 0

func _ready() -> void:
	estructura = datos.estructura.duplicate()
	estructurar_planta()
	

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("aceptar") and focus:
		#seleccionar_planta()

#func _input(event: InputEvent) -> void:
	##if pieza_seleccionada:
	#if Input.is_action_pressed("girar_derecha") and giro_actual<3: giro_actual += 1; girar_planta()
	#elif Input.is_action_pressed("girar_derecha"):giro_actual = 0; girar_planta()
	#elif Input.is_action_pressed("girar_izquierda") and giro_actual>0:giro_actual -= 1; girar_planta()
	#elif Input.is_action_pressed("girar_izquierda"): giro_actual = 3; girar_planta()

#region GETERS
func get_id_planta() -> int: return id_planta
func get_seleccion()->bool: return pieza_seleccionada
func get_nombre_planta() -> String:
	if datos: return datos.nombre_planta 
	else: return ""
func get_tile_de_planta() -> Vector2i:
	if datos: return datos.tile_de_planta
	else: return Vector2i(0,0)
func get_tile_alternativo() -> int:
	if datos: return datos.tile_alternativo
	else: return 0
func get_focus() -> bool: return focus
func get_estructura() -> Array[Vector2i]:
	if datos: return estructura
	else: return []
func get_tipo_planta() -> Dios.Especie:
	if datos: return datos.tipo_de_planta
	else: return 0
#endregion

func set_id_planta(valor:int):
	id_planta = valor

func estructurar_planta():
	for modulo in datos.estructura:
		var tamaño_tile:Vector2i = Vector2i(datos.tamaño_de_tiles,datos.tamaño_de_tiles) 
		var posicion_nueva:Vector2i = Vector2i(tamaño_tile.x*modulo.x,tamaño_tile.y*modulo.y)
		var imagen:Sprite2D = Sprite2D.new() 
		var tamaño_area:CollisionShape2D = CollisionShape2D.new()
		var forma_area:RectangleShape2D = RectangleShape2D.new()
		imagen.texture = datos.textura
		imagen.position = posicion_nueva
		tamaño_area.shape = forma_area
		tamaño_area.position = posicion_nueva
		forma_area.size = tamaño_tile
		add_child(imagen)
		area_2d.add_child(tamaño_area)

func prender_focus():
	emit_signal("en_focus",self)
	focus = true
	print(focus)
func apagar_focus():
	focus = false
	print(focus)

#func poner_mariposa(mariposa):
	#hay_mariposa = true
	#
#func sacar_mariposa(mariposa):
	#hay_mariposa = false
	
func girar_planta():
	estructura.clear()
	match giro_actual:
		0: 
			for posicion in datos.estructura:
				estructura.append(posicion)
			rotation = 0
			print(estructura)
		1:
			for posicion in datos.estructura:
				estructura.append(Vector2i(posicion.y*(-1),posicion.x))
			rotation = PI/2
			print(estructura)
		2:
			for posicion in datos.estructura:
				estructura.append(posicion*-1)
			rotation = PI
			print(estructura)
		3:
			for posicion in datos.estructura:
				estructura.append(Vector2i(posicion.y*(-1),posicion.x)*(-1))
			rotation = PI*1.5
			print(estructura)

#func seleccionar_planta():
	#if !hay_mariposa:
		#pieza_seleccionada = true
		#emit_signal("seleccionado",self)
func soltar_planta():
	pieza_seleccionada = false
	emit_signal("soltando")
func activar_boton():
	emit_signal("eliminando")
