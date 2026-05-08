extends Node2D
class_name Planta
signal soltando  
signal en_focus(planta:Planta)
signal eliminando

@onready var area_2d: Area2D = $Area2D
var id_planta:int = 0
var pieza_seleccionada:bool = false

var key_planta:String
var key_estructura:String
var estructura:Array[Vector2i]

var hay_mariposa:bool = false
var focus = true
@onready var giro_actual:int = 0


#region
func get_id_planta() -> int: return id_planta
func get_nombre_planta() -> String:
	return Dios.bd_interna["plantas"][key_planta]["nombre_comun"]
func get_focus() -> bool: return focus
func get_estructura() -> Array[Vector2i]:
	return estructura
func get_tipo_planta() -> String:
	return key_planta
func set_id_planta(valor:int):
	id_planta = valor
#endregion

func estructurar_planta():
	for modulo in estructura:
		var tamaño_tile:Vector2i = Vector2i(64,64) 
		var posicion_nueva:Vector2i = Vector2i(tamaño_tile.x*modulo.x,tamaño_tile.y*modulo.y)
		var imagen:Sprite2D = Sprite2D.new() 
		var tamaño_area:CollisionShape2D = CollisionShape2D.new()
		var forma_area:RectangleShape2D = RectangleShape2D.new()
		
		var ruta_textura = Dios.bd_interna["plantas"][key_planta]["imagen_catalogo"]
		var textura_cargada = load(ruta_textura)
		
		imagen.texture = textura_cargada
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

func girar_planta():
	var lista_cruda = Dios.bd_interna["plantas"][key_planta]["forma"][key_estructura].duplicate()
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

func soltar_planta():
	pieza_seleccionada = false
	emit_signal("soltando")
func activar_boton():
	emit_signal("eliminando")
