extends Node2D
class_name Jardin

signal mariposa_jardin_cambio(valor)
@export var columnas:int
@onready var jardinero: ControlTablero = $Jardinero
@onready var naturaleza: Naturaleza = $Naturaleza
@onready var origen_plantas: Node2D = $origen_plantas
@onready var tablero: Tablero = $Tablero
@onready var capa_plantas: TileMapLayer = $capa_plantas


func emitir_suma_de_puntos():
	emit_signal("mariposa_jardin_cambio")

func establecer_columnas(valor):
	columnas = valor
