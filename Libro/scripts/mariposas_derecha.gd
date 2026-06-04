extends Control
signal pasando_pagina

const ORUGABA_BLOQUEADA = preload("uid://bt3rw86lieit6")

@onready var postal_planta_1: HBoxContainer = $MarginContainer/ContenedorGeneral/EstampitasCont/PostalPlanta1
@onready var boton_postal_1: TextureButton = $MarginContainer/ContenedorGeneral/EstampitasCont/PostalPlanta1/ratio/boton
@onready var texto_1: RichTextLabel = $MarginContainer/ContenedorGeneral/EstampitasCont/PostalPlanta1/ratio/boton/canva/Cartel/Texto

@onready var postal_planta_2: HBoxContainer = $MarginContainer/ContenedorGeneral/EstampitasCont/PostalPlanta2
@onready var boton_postal_2: TextureButton = $MarginContainer/ContenedorGeneral/EstampitasCont/PostalPlanta2/AspectRatioContainer/boton
@onready var texto_2: RichTextLabel = $MarginContainer/ContenedorGeneral/EstampitasCont/PostalPlanta2/AspectRatioContainer/boton/Control/Cartel/Texto

@onready var postal_planta_3: HBoxContainer = $MarginContainer/ContenedorGeneral/EstampitasCont/PostalPlanta3
@onready var boton_postal_3: TextureButton = $MarginContainer/ContenedorGeneral/EstampitasCont/PostalPlanta3/AspectRatioContainer/boton
@onready var texto_3: RichTextLabel = $MarginContainer/ContenedorGeneral/EstampitasCont/PostalPlanta3/AspectRatioContainer/boton/Control/Cartel/Texto

@onready var imagen_oruga: TextureButton = $MarginContainer/ContenedorGeneral/SegundaSeccion/Oruga/Boton
@onready var hojita: TextureRect = $MarginContainer/ContenedorGeneral/SegundaSeccion/Oruga/Boton/Canva/hojita
@onready var dato_curioso_2: RichTextLabel = $MarginContainer/ContenedorGeneral/SegundaSeccion/DatosCuriosos/ScrollContainer/contenedor/DatoCurioso2

var oculto:String = "???"

func generar_datos(especimen):
	var ruta_imagen_oruga = Dios.bd_interna["mariposas"][especimen]["textura_oruga_libro"]
	var texto_dato_curioso = Dios.bd_interna["mariposas"][especimen]["dato_curioso_2"]
	var lista_plantas_requeridas = Dios.bd_interna["mariposas"][especimen]["plantas_requeridas"].duplicate()
	var ruta_hojita = Dios.bd_interna["plantas"][lista_plantas_requeridas[0]]["hoja"]
	var nombre_mariposa = Dios.bd_interna["mariposas"][especimen]["nombre"]
	
	var lista_postales: Array = [
		[postal_planta_1, boton_postal_1, texto_1],
		[postal_planta_2, boton_postal_2, texto_2],
		[postal_planta_3, boton_postal_3, texto_3]
	]
	
	postal_planta_3.hide()
	var lista_desbloqueo = Dios.bd_externa["progreso_mariposas"][especimen]
	cargar_imagen_oruga(lista_desbloqueo,ruta_imagen_oruga,ORUGABA_BLOQUEADA)
	cargar_dato_oculto_1(lista_desbloqueo,texto_dato_curioso)
	cargar_postales(lista_desbloqueo,lista_plantas_requeridas,nombre_mariposa,lista_postales)
	hojita.texture = load(ruta_hojita)

func cargar_imagen_oruga(lista_desbloqueo,ruta_textura,textura_bloqueo):
	if ruta_textura in lista_desbloqueo:
		imagen_oruga.texture_normal = load(ruta_textura)
	else :
		imagen_oruga.texture_normal = textura_bloqueo
func cargar_dato_oculto_1(lista_desbloqueo,dato_curioso):
	if dato_curioso in lista_desbloqueo:
		dato_curioso_2.text = dato_curioso
	else :
		dato_curioso_2.text = oculto
func cargar_postales(lista_desbloqueo, lista_plantas_requeridas, nombre_mariposa, lista_postales_nodos):
	for i in range(lista_plantas_requeridas.size()):
		var boton_postal = lista_postales_nodos[i][1]
		
		for conexion in boton_postal.pressed.get_connections():
			boton_postal.pressed.disconnect(conexion.callable)
			
		for conexion in boton_postal.mouse_entered.get_connections():
			boton_postal.mouse_entered.disconnect(conexion.callable)
		for conexion in boton_postal.mouse_exited.get_connections():
			boton_postal.mouse_exited.disconnect(conexion.callable)

		var planta = lista_plantas_requeridas[i]
		hojita.show()
		var ruta_imagen_postal = Dios.bd_interna["plantas"][planta]["postal"]
		
		lista_postales_nodos[i][0].show()
		boton_postal.pressed.connect(_seleccionar_planta.bind(planta))
		lista_postales_nodos[i][2].text = planta
		
		boton_postal.texture_normal = load(ruta_imagen_postal)
		
		boton_postal.self_modulate = Color(1, 1, 1, 1)
		
		boton_postal.mouse_entered.connect(func(): 
			boton_postal.self_modulate = Color(1.4, 1.4, 1.4, 1) 
		)
		
		boton_postal.mouse_exited.connect(func(): 
			boton_postal.self_modulate = Color(1, 1, 1, 1) 
		)

func _seleccionar_planta(planta: String):
	emit_signal("pasando_pagina", "planta", planta)
