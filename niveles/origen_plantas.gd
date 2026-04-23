extends Node2D

@onready var planta_escena = preload("uid://der8d61kw3xr8")
@export var jardinero: ControlTablero
@onready var jardin: Node2D = $".."


func crear_planta(recurso, boton_original):
	var nueva_planta = planta_escena.instantiate()
	nueva_planta.datos = recurso
	jardin.add_child(nueva_planta) 
	nueva_planta.eliminando.connect(boton_original.mostrar_imagen)
	nueva_planta.scale *= scale
	nueva_planta.z_index = 2
	nueva_planta.set_id_planta(boton_original.get_index() + 1)
	jardinero.seleccionar_planta(nueva_planta)
