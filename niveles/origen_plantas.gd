extends Node2D

@onready var planta_escena = preload("uid://der8d61kw3xr8")
@export var jardinero: ControlTablero
@onready var jardin: Node2D = $".."


func crear_planta(key_planta,key_estructura, estructura, boton_original, ejemplar):
	var nueva_planta:Planta = planta_escena.instantiate()
	#nueva_planta.giro_actual = 0
	nueva_planta.key_planta = key_planta
	nueva_planta.key_estructura = key_estructura
	nueva_planta.estructura = estructura.duplicate()
	jardin.add_child(nueva_planta) 
	nueva_planta.eliminando.connect(boton_original.mostrar_imagen)
	nueva_planta.scale *= scale
	nueva_planta.z_index = 2
	nueva_planta.set_id_planta(boton_original.get_index() + 1)
	nueva_planta.ejemplar = ejemplar
	nueva_planta.estructurar_planta() # pasar parametro
	jardinero.seleccionar_planta(nueva_planta)
