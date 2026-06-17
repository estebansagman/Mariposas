extends Node2D
class_name ObjetosMoviles

signal soltando  
signal en_focus(objeto:ObjetosMoviles)
signal eliminando

const VFXGIRO = preload("uid://dev3eecridu31")
var particulas_activas = false

const ZINDEX_ORIGEN:int=3
const ZINDEX_SELECCION:int=10

@onready var area_2d: Area2D = $Area2D
var id_objeto:int = 0
var pieza_seleccionada:bool = false
var coordenada_celda:Vector2i
var posicion_anterior:Array[Vector2i]

var key_objeto:String
var estructura:Array[Vector2i]


var hay_mariposa:bool = false
var focus = true
var giro_actual:int = 0

#var ejemplar:String

#region
func get_id_objeto() -> int: return id_objeto
func get_nombre_objeto() -> String:
	return Dios.bd_interna["objetos"][key_objeto]["objeto"]
func get_focus() -> bool: return focus
func get_estructura() -> Array[Vector2i]:
	return estructura
func get_tipo_planta() -> String:
	return key_objeto
func set_id_objeto(valor:int):
	id_objeto = valor
#endregion

func estructurar_objeto():
	#print("A VER SI SE LA BANCA: ",estructura) Sigue bien
	var ejemplar = Dios.bd_interna["objetos"][key_objeto]["forma_superficial"]
	var objeto = load(ejemplar)
	var forma_superficial = objeto.instantiate()
	add_child(forma_superficial)
	for modulo in estructura:
		var tamaño_tile:Vector2i = Vector2i(64,64) 
		var posicion_nueva:Vector2i = Vector2i(tamaño_tile.x*modulo.x,tamaño_tile.y*modulo.y)
		var tamaño_area:CollisionShape2D = CollisionShape2D.new()
		var forma_area:RectangleShape2D = RectangleShape2D.new()
		tamaño_area.shape = forma_area
		tamaño_area.position = posicion_nueva
		forma_area.size = tamaño_tile
		area_2d.add_child(tamaño_area)
	generar_posicion_anterior()

func generar_posicion_anterior():
	if posicion_anterior.is_empty():
		posicion_anterior.clear() 
		for modulo in estructura:
			var celda_real: Vector2i = coordenada_celda + modulo
			posicion_anterior.append(celda_real)
		

func prender_focus():
	emit_signal("en_focus",self)
	focus = true
	print(focus)
func apagar_focus():
	focus = false
	print(focus)

func girar_objeto(gira_derecha:bool):
	var t = create_tween()
	var duracion = 0.1
	var sentido_de_giro = 1
	if !gira_derecha: sentido_de_giro = -1
	var rotacion_aplicada = rotation + (PI/2)*sentido_de_giro
	t.tween_property(self,"rotation",rotacion_aplicada,duracion)
	await t.finished
	giro_de_objeto()
func giro_de_objeto():
	var lista_cruda = Dios.bd_interna["objetos"][key_objeto]["forma"].duplicate()
	var forma_inicial = Dios.transformar_en_vector2i(lista_cruda)
	estructura.clear()
	for posicion in forma_inicial:
		match giro_actual:
			0:
				estructura.append(posicion)
				rotation = 0
			1:
				estructura.append(Vector2i(-posicion.y, posicion.x))
				rotation = PI/2
			2:
				estructura.append(Vector2i(-posicion.x, -posicion.y))
				rotation = PI
			3:
				estructura.append(Vector2i(posicion.y, -posicion.x))
				rotation = PI * 1.5

func emitir_particulas_giro(direccion)->void:
	if particulas_activas:
		return
	particulas_activas = true
	var vfx:GPUParticles2D = VFXGIRO.instantiate()
	add_child(vfx)
	vfx.scale*=get_parent().scale*10
	if direccion == "izquierda":
		vfx.process_material.orbit_velocity_min = 0.5
		vfx.process_material.orbit_velocity_max = 0.8
	elif direccion == "derecha":
		vfx.process_material.orbit_velocity_min = -0.8
		vfx.process_material.orbit_velocity_max = -0.5
	vfx.top_level = true
	vfx.global_position = get_global_mouse_position()
	vfx.emitting = true
	await vfx.finished
	vfx.queue_free()
	particulas_activas = false

func soltar_objeto():
	pieza_seleccionada = false
	emit_signal("soltando")
func activar_boton():
	emit_signal("eliminando")
