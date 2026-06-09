extends Node2D

@onready var planta_escena = preload("uid://der8d61kw3xr8")
@onready var objeto_escena = preload("uid://csae5pte6k7x6")
@export var jardinero: ControlTablero
@onready var jardin: Node2D = $".."

func crear_planta(key_planta,key_estructura, estructura, boton_original, ejemplar):
	var nueva_planta:Planta = planta_escena.instantiate()
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

func crear_objeto(key_objeto, estructura, boton_original):
	var nuevo_objeto:ObjetosMoviles = objeto_escena.instantiate()
	nuevo_objeto.key_objeto = key_objeto
	#nuevo_objeto.key_estructura = key_estructura
	nuevo_objeto.estructura = estructura.duplicate()
	#print("aca estamos bien?: ",nuevo_objeto.estructura) VA BIEN
	jardin.add_child(nuevo_objeto) 
	nuevo_objeto.eliminando.connect(boton_original.mostrar_imagen)
	nuevo_objeto.scale *= scale
	nuevo_objeto.z_index = 2
	nuevo_objeto.set_id_objeto(boton_original.get_index() + 1)
	#nuevo_objeto.ejemplar = ejemplar
	nuevo_objeto.estructurar_objeto()
	jardinero.seleccionar_objeto(nuevo_objeto)
