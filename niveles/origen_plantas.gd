extends Node2D

@onready var planta_escena = preload("uid://der8d61kw3xr8")
@export var jardinero: ControlTablero

func _on_pedido_de_planta(recurso, boton_original):
	var nueva_planta = planta_escena.instantiate()
	nueva_planta.datos = recurso
	jardinero.jardin.add_child(nueva_planta) 
	nueva_planta.eliminando.connect(boton_original.mostrar_imagen)
	nueva_planta.scale *= 7.859
	nueva_planta.z_index = 2
	nueva_planta.set_id_planta(boton_original.get_index() + 1)
	jardinero.seleccionar_planta(nueva_planta)
