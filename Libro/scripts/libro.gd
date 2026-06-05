extends Control
class_name libro

const LIBRO_3D = preload("uid://bshljp84410s4")

@onready var pagina_izquierda: Pagina = $Control/Izquierda
@onready var pagina_derecha: Pagina = $Control/Derecha
@onready var hoja: Hoja = $Control/SubViewportContainer/SubViewport/Hoja
@onready var sub_viewport_container: SubViewportContainer = $Control/SubViewportContainer

var pagina_actual:int = 0
var paginas:Array = [["indice",""]]
var botones_activados:bool = true


func abrir():
	show()
	get_tree().paused = true
	establecer_paginas()
	print("lista: ",paginas)
	pagina_izquierda.mostrar_cara("izquierda",paginas[pagina_actual][0],paginas[pagina_actual][1])
	pagina_derecha.mostrar_cara("derecha",paginas[pagina_actual][0],paginas[pagina_actual][1])
func cerrar():
	get_tree().paused = false
	hide()
	
func establecer_paginas():
	var paginas_mariposa:Array = Dios.bd_interna["orden_inportancia_mariposas"]
	var paginas_plantas:Array = Dios.bd_interna["orden_planta"]
	sumar_paginas("mariposa",paginas_mariposa)
	sumar_paginas("planta",paginas_plantas)
func sumar_paginas(tipo_de_pagina,especimenes):
	for especimen in especimenes:
		paginas.append([tipo_de_pagina,especimen])

func ir_a_pagina(tipo_hoja, especimen=""):
	print("los datos que llegan son: ",tipo_hoja," y ",especimen," | Boton: ",botones_activados)
	
	if botones_activados: 
		botones_activados = false 
	else: 
		return
	
	var pagina_destino = paginas.find([tipo_hoja, especimen])
	if pagina_destino == -1 or pagina_destino == pagina_actual or pagina_actual < 0:
		activar_botones()
		return
		
	var cantidad_de_paginas = abs(pagina_destino - pagina_actual)
	var orientacion:String
	var hacia_adelante:bool
	var ruta_paginas: Array
	var max_indice = paginas.size() - 1
	
	if pagina_destino > pagina_actual:
		orientacion = "derecha"
		hacia_adelante = true
		for i in range(pagina_actual + 1, pagina_destino + 1): 
			ruta_paginas.append(i)
	else:
		orientacion = "izquierda"
		hacia_adelante = false
		for i in range(pagina_actual - 1, pagina_destino - 1, -1):
			ruta_paginas.append(i)

	pagina_actual = pagina_destino
	await pasar_paginas_modo_rafaga(cantidad_de_paginas, orientacion, hacia_adelante, ruta_paginas)
	activar_botones()
func _pasar_pagina():
	var validacion = (pagina_actual > 14)or(not botones_activados)
	if validacion:return
	botones_activados = false 
	pagina_actual = clamp(pagina_actual + 1, 0, 15)
	await hoja.cambiar_imagenes(pagina_actual, paginas, true)
	hoja.pasar_pagina()
func _volver_a_la_pagina_anterior():
	var validacion = (pagina_actual < 1)or(not botones_activados)
	if validacion:return
	botones_activados = false 
	pagina_actual = clamp(pagina_actual-1,0,15)
	await hoja.cambiar_imagenes(pagina_actual, paginas,false)
	hoja.volver_a_la_pagina_anterior()
	#activar_botones()
	
func pasar_paginas_modo_rafaga(cantidad_de_paginas: int, orientacion: String, hacia_adelante: bool, ruta_paginas: Array):
	var contenedor_viewport = $Control/SubViewportContainer/SubViewport
	var lista_hojas: Array
	hoja.prender_hoja()
	
	for i in range(cantidad_de_paginas):
		var clon: Hoja = LIBRO_3D.instantiate()
		clon.es_clon_rafaga = true
		contenedor_viewport.add_child(clon)
		clon.hide()

		var numero_pagina_clon = ruta_paginas[i]
		clon.cambiar_imagenes(numero_pagina_clon, paginas, hacia_adelante)
		lista_hojas.append(clon)
	
	lista_hojas[-1].es_clon_rafaga = false
	lista_hojas[-1].izquierda_cambia.connect(self._cambiar_pagina_izquierda) 
	lista_hojas[-1].derecha_cambia.connect(self._cambiar_pagina_derecha)     
	lista_hojas[-1].animacion_finaliza.connect(self.activar_botones)

	await get_tree().process_frame
	hoja.apagar_hoja()

	for hoja_rapida in lista_hojas:
		hoja_rapida.show()
		hoja_rapida.pasar_rapido(orientacion)
		await get_tree().create_timer(0.08).timeout
	activar_botones()
func _cambiar_pagina_izquierda():
	pagina_izquierda.mostrar_cara("izquierda",paginas[pagina_actual][0],paginas[pagina_actual][1])
func _cambiar_pagina_derecha():
	pagina_derecha.mostrar_cara("derecha",paginas[pagina_actual][0],paginas[pagina_actual][1])

func activar_botones():
	print("hipoteticamente finalizo...")
	botones_activados = true
