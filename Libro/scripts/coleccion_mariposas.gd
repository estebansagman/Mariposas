extends Control
signal pasando_pagina

const BOTON_MARIPOSA_LIBRO = preload("uid://dsnkqvhnhjtul")

@export var columnas:int
@onready var lista_mariposas:Array = Dios.bd_interna["orden_inportancia_mariposas"]
@onready var filas: VBoxContainer = $Pagina1/Filas

var mariposa_seleccionada:String


func _crear_accesos():
	if lista_mariposas.is_empty():
		print("lista vacia")
		return

	for hijo in filas.get_children():
		hijo.queue_free()
		
	var agregadas:int = 0
	var contenedor:HBoxContainer
	for mariposa in lista_mariposas:
		if agregadas%columnas==0:
			contenedor = HBoxContainer.new()
			filas.add_child(contenedor)
		agregadas+=1
		var nuevo_boton_mariposa:= BOTON_MARIPOSA_LIBRO.instantiate()
		nuevo_boton_mariposa.mariposa = mariposa
		nuevo_boton_mariposa.pressed.connect(_seleccionar_mariposa.bind(nuevo_boton_mariposa.mariposa))
		contenedor.add_child(nuevo_boton_mariposa)
		var desbloqueado = Dios.bd_externa["progreso_mariposas"][mariposa]
		var ruta_textura = Dios.bd_interna["mariposas"][mariposa]["textura_juego"]
		var textura = load(ruta_textura)
		nuevo_boton_mariposa.texture_rect.texture = textura
		print(desbloqueado)
		
		if !desbloqueado.is_empty():
			nuevo_boton_mariposa.texture_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else :
			nuevo_boton_mariposa.texture_rect.modulate = Color(0.0, 0.0, 0.0, 1.0)

func _seleccionar_mariposa(mariposa:String):
	mariposa_seleccionada = mariposa
	emit_signal("pasando_pagina",mariposa)
