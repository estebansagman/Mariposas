extends Control
signal pasando_pagina(tipo_de_pagina,especimen)

const CONTENEDOR_ACCESOS = preload("uid://e0yfifw5xtxu")
const POLAROID_VACIA = preload("uid://cbqhid1akseog")

@export var columnas:int
@export_enum(
	"mariposas",
	"plantas"
) var tipo_de_boton:int

@onready var lista_mariposas:Array = Dios.bd_interna["orden_inportancia_mariposas"]
@onready var lista_plantas:Array = Dios.bd_interna["orden_planta"]
@onready var filas: VBoxContainer = $MarginContainer/Filas
var oculto: String = "???"

func crear_accesos():
	var lista_items:Array
	if tipo_de_boton == 0:
		if lista_mariposas.is_empty(): return
		else: lista_items = lista_mariposas.duplicate()
	else:
		if lista_plantas.is_empty(): return
		else: lista_items = lista_plantas.duplicate()

	for hijo in filas.get_children():
		hijo.queue_free()

	var agregadas:int = 0
	var contenedor:HBoxContainer
	for item in lista_items:
		if agregadas%columnas==0:
			contenedor = HBoxContainer.new()
			contenedor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			contenedor.size_flags_vertical = Control.SIZE_EXPAND_FILL
			filas.add_child(contenedor)
		agregadas+=1
		var boton_cont:= CONTENEDOR_ACCESOS.instantiate()
		contenedor.add_child(boton_cont)
		var desbloqueado
		var ruta_textura
		var titulo
		if tipo_de_boton == 0:
			boton_cont.boton.pressed.connect(_seleccionar_mariposa.bind(item))
			desbloqueado = Dios.bd_externa["progreso_mariposas"][item].duplicate()
			ruta_textura = Dios.bd_interna["mariposas"][item]["textura_libro"]
			titulo = Dios.bd_interna["mariposas"][item]["nombre"]
			if !desbloqueado.is_empty():
				boton_cont.item.texture = load(ruta_textura)
				boton_cont.titulo.text = titulo
			else:
				boton_cont.item.texture = POLAROID_VACIA
				boton_cont.titulo.text = oculto
		else:
			boton_cont.boton.pressed.connect(_seleccionar_planta.bind(item))
			ruta_textura = Dios.bd_interna["plantas"][item]["imagen_libro"]
			titulo = Dios.bd_interna["plantas"][item]["nombre_comun"]
			boton_cont.item.texture = load(ruta_textura)
			boton_cont.titulo.text = titulo

func _seleccionar_mariposa(mariposa:String):
	emit_signal("pasando_pagina","mariposa",mariposa)


func _seleccionar_planta(planta:String):
	emit_signal("pasando_pagina","planta",planta)
