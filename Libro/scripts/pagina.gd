extends Control
class_name Pagina

@onready var pagina_indice: Control = $PaginaIndice
@onready var pagina_mariposa: Control = $PaginaMariposa
@onready var pagina_planta: Control = $PaginaPlanta
var tipo_de_pagina: String = "mariposa"
var especimen: String = "bandera_argentina"

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
