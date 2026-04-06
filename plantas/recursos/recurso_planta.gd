@tool 
extends Resource
class_name RecursoPlanta

@export var nombre_planta: String
@export var tipo_de_planta: Dios.Especie
@export var textura: Texture2D
@export var estructura: Array[Vector2i]:
	set(valor):
		estructura = valor
		_dibujar_en_consola()
@export var tamaño_de_tiles: int = 64
@export var actualizar:bool:
	set(valor):
		actualizar = valor
		_dibujar_en_consola()
@export var textura_descripcion:Texture2D

func _dibujar_en_consola(): # Herramienta momentanea para armar las plantas
	#Dios.limpiar_pantalla_visual()
	var coorenadas = estructura
	if coorenadas.is_empty():
		print("Planta vacía.")
		return
		
	var min_x = 0; var max_x = 0
	var min_y = 0; var max_y = 0
	for v in coorenadas:
		min_x = min(min_x, v.x)
		max_x = max(max_x, v.x)
		min_y = min(min_y, v.y)
		max_y = max(max_y, v.y)
		
	var dibujo = "\n--- " + (nombre_planta if nombre_planta else "Sin Nombre") + " ---\n"
	for y in range(min_y, max_y + 1):
		var linea = ""
		for x in range(min_x, max_x + 1):
			linea += "[X] " if Vector2i(x, y) in coorenadas else "[ ] "
		dibujo += linea + "\n"
	print(dibujo + "------------------\n")
func _limpiar_pantalla_visual(): 
	for i in range(50):
		print("")
