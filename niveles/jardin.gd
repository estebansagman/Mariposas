extends Node2D
class_name Jardin

signal mariposa_jardin_cambio(valor)
@export var columnas:int
@onready var jardinero: ControlTablero = $Jardinero
@onready var naturaleza: Naturaleza = $Naturaleza
@onready var origen_plantas: Node2D = $origen_plantas

func emitir_suma_de_puntos(valor):
	emit_signal("mariposa_jardin_cambio",valor)

func establecer_columnas(valor):
	columnas = valor
