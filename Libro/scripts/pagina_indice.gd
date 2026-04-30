extends Control

@onready var coleccion_mariposas: Control = $HojaDerecha/ColeccionMariposas
@onready var coleccion_plantas: Control = $HojaDerecha/ColeccionPlantas

func _mostrar_indice_plantas():
	coleccion_mariposas.hide()
	coleccion_plantas.show()

func _mostrar_indice_mariposas():
	coleccion_mariposas._crear_accesos()
	coleccion_plantas.hide()
	coleccion_mariposas.show()
