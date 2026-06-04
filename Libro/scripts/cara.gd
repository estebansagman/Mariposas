extends Control
class_name Cara

@onready var mariposas: Control = $Mariposas
@onready var plantas: Control = $Plantas
@onready var indice: Control = $Indice

func mostrar_indice():
	indice.show()
	mariposas.hide()
	plantas.hide()
	indice.crear_accesos()
	
func mostrar_mariposa(especimen):
	indice.hide()
	mariposas.show()
	plantas.hide()
	mariposas.generar_datos(especimen)

func mostrar_planta(especimen):
	indice.hide()
	mariposas.hide()
	plantas.show()
	plantas.generar_datos(especimen)
