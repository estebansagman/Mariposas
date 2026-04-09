extends Node2D
@export var numero_de_nivel:int
@onready var ui: Control = $UI


var estrellas:int
var puntos_maximos:int

func _ready() -> void:
	ui.pasar_datos_puntaje(numero_de_nivel)
	
func ir_al_siguiente():
	var numero_actual = name.to_int() 
	var siguiente_ruta = "res://niveles/niveles/Nivel_" + str(numero_de_nivel + 1) + ".tscn"
	if ResourceLoader.exists(siguiente_ruta):
		get_tree().change_scene_to_file(siguiente_ruta)
	else:
		print("¡No hay más niveles!")
