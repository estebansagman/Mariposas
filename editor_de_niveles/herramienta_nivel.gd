@tool
extends Node
class_name EditorNiveles

@export_range(2,15) var columnas:int:
	set(valor):
		columnas = valor
		if Engine.is_editor_hint():
			actualizar_tablero_visual()
@export var limpiar:bool = false
@export var tablero: TileMapLayer
@export var jardin: Node2D
@onready var jardinero: ControlTablero = $"../Jardinero"


func actualizar_tablero_visual():
	print("Redibujando tablero de ", columnas, " columnas")
	jardin.scale = Vector2(1/float(columnas),1/float(columnas))
	#jardinero.columnas = columnas
	if limpiar:
		tablero.clear()
		for columna in range(columnas):
			for casilla in range(columnas):
				tablero.set_cell(Vector2i(casilla,columna),1,Vector2i(0,0))
				print(casilla)
