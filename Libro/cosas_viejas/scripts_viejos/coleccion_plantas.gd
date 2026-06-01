extends Control
signal pasando_pagina

const BOTON_PLANTA_LIBRO = preload("uid://c0sgj6na6ri3d")

@export var columnas:int
@onready var lista_plantas:Array = Dios.bd_interna["orden_planta"]
@onready var filas: VBoxContainer = $Pagina1/Filas

var planta_seleccionada:String

func _ready() -> void:
	print(lista_plantas)
	_crear_accesos()

func _crear_accesos():
	if lista_plantas.is_empty():
		print("lista vacia")
		return

	var agregadas:int = 0
	var contenedor:HBoxContainer
	for planta in lista_plantas:
		if agregadas%columnas==0:
			contenedor = HBoxContainer.new()
			filas.add_child(contenedor)
		agregadas+=1
		var nuevo_boton_planta:= BOTON_PLANTA_LIBRO.instantiate()
		nuevo_boton_planta.planta = planta
		nuevo_boton_planta.pressed.connect(_seleccionar_planta.bind(nuevo_boton_planta.planta))
		contenedor.add_child(nuevo_boton_planta)
		

func _seleccionar_planta(planta:String): # me parece que esto lo maneja directo el boton 
	planta_seleccionada = planta
	emit_signal("pasando_pagina",planta)
