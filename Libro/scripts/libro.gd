extends Control
class_name libro

@onready var pagina_indice: Control = $PaginaIndice
@onready var pagina_mariposa: Control = $PaginaMariposa
@onready var pagina_planta: Control = $PaginaPlanta
@onready var hoja: Hoja = $"Control/SubViewportContainer/SubViewport/TEST Libro"
var cantidad_de_hojas:int
var pagina_actual:int = 1
var paginas:Array

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pasar_pagina"):
		hoja.pasar_pagina()
	if Input.is_action_just_pressed("volver_pagina"):
		hoja.volver_a_la_pagina_anterior()
	if Input.is_action_just_pressed("girar_derecha"):
		pasar_paginas_modo_rafaga(8,"derecha")
	if Input.is_action_just_pressed("girar_izquierda"):
		pasar_paginas_modo_rafaga(8,"izquierda")

func _ready() -> void:
	establecer_paginas()

func establecer_paginas():
	var paginas_mariposa:Array = Dios.bd_interna["orden_inportancia_mariposas"]
	var paginas_plantas:Array = Dios.bd_interna["orden_planta"]
	sumar_paginas(paginas_mariposa)
	sumar_paginas(paginas_plantas)
	cantidad_de_hojas = paginas.size()
	print("La cantidad de hojas es: ",cantidad_de_hojas)

func sumar_paginas(lista_paginas):
	for pagina in lista_paginas:
		paginas.append(pagina)

func abrir():
	show()
	_abrir_indice()
func cerrar():
	hide()
func _abrir_indice():
	pagina_mariposa.hide()
	pagina_planta.hide()
	pagina_indice.show()
	pagina_indice._mostrar_indice_mariposas()
	pagina_indice.coleccion_mariposas._crear_accesos()
func _abrir_pagina_mariposa(mariposa):
	pagina_mariposa.cargar_datos(mariposa)
	pagina_indice.hide()
	pagina_planta.hide()
	pagina_mariposa.show()
func _abrir_pagina_planta(planta):
	pagina_planta.cargar_datos(planta)
	pagina_indice.hide()
	pagina_mariposa.hide()
	pagina_planta.show()

func _pasar_pagina():
	hoja.pasar_pagina()
func _volver_a_la_pagina_anterior():
	hoja.volver_a_la_pagina_anterior()
func pasar_paginas_modo_rafaga(cantidad_de_paginas: int,orientacion:String):
	var contenedor_viewport = $Control/SubViewportContainer/SubViewport
	var lista_hojas:Array

	hoja.prender_hoja()
	for i in range(cantidad_de_paginas):
		var clon = hoja.duplicate()
		contenedor_viewport.add_child(clon)
		lista_hojas.append(clon)
	await get_tree().create_timer(0.1).timeout
	hoja.apagar_hoja()

	for hoja_rapida in lista_hojas:
		hoja_rapida.pasar_rapido(orientacion)
		await get_tree().create_timer(0.08).timeout
