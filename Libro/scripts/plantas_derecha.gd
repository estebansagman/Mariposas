extends Control
signal pasando_pagina

@onready var polaroid_cont: VBoxContainer = $MarginContainer/ContenedorGeneral/Seccion1/PolaroidCont
@onready var polaroid_1: PolaroidBotonMariposa = $MarginContainer/ContenedorGeneral/Seccion1/PolaroidCont/Polaroid

@onready var polaroid_cont_2: VBoxContainer = $MarginContainer/ContenedorGeneral/Seccion1/PolaroidCont2
@onready var polaroid_2: PolaroidBotonMariposa = $MarginContainer/ContenedorGeneral/Seccion1/PolaroidCont2/Polaroid

@onready var planta_a: TextureRect = $MarginContainer/ContenedorGeneral/Seccion2/PlantaA
@onready var planta_b: TextureRect = $MarginContainer/ContenedorGeneral/Seccion2/PlantaB

func generar_datos(especimen):
	var lista_mariposas_atraidas = Dios.bd_interna["plantas"][especimen]["mariposas_atraidas"].duplicate()
	var formas_planta = Dios.bd_interna["plantas"][especimen]["imagen_catalogo"]

	#var lista_desbloqueo = Dios.bd_externa["progreso_mariposas"][especimen]

	var lista_botones_polaroid: Array = [[polaroid_cont, polaroid_1], [polaroid_cont_2, polaroid_2]]
	var lista_formas_planta: Array = [planta_a, planta_b]

	for par in lista_botones_polaroid:
		par[0].hide()

		for conexion in par[1].boton.pressed.get_connections():
			par[1].boton.pressed.disconnect(conexion.callable)

	for i in range(lista_mariposas_atraidas.size()):
		if i >= lista_botones_polaroid.size(): 
			break
			
		var contenedor = lista_botones_polaroid[i][0]
		var polaroid = lista_botones_polaroid[i][1]
		var mariposa_id = lista_mariposas_atraidas[i]
		var nombre_mariposa = Dios.bd_interna["mariposas"][mariposa_id]["nombre"]
		var lista_desbloqueo = Dios.bd_externa["progreso_mariposas"][mariposa_id]
		
		contenedor.show()
		polaroid.rellenar(mariposa_id)
		polaroid.boton.pressed.connect(_seleccionar_mariposa.bind(mariposa_id))
		if nombre_mariposa in lista_desbloqueo:
			polaroid.boton.pressed.connect(_seleccionar_mariposa.bind(mariposa_id))
			print("conectado ", mariposa_id, "!")
		else:
			print("no debloqueado.")

	for i in range(formas_planta.size()):
		if i < lista_formas_planta.size():
			lista_formas_planta[i].texture = load(formas_planta[i])

func _seleccionar_mariposa(mariposa:String):
	emit_signal("pasando_pagina","mariposa",mariposa)
	print("llendooo a "+mariposa)
