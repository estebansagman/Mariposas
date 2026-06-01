extends Control
signal pasando_pagina

#const BOTON = preload("uid://dsnkqvhnhjtul")
#const CONTENEDOR_GUIAS = preload("uid://bpkax36b2yb4a")
const CONTENEDOR_ACCESOS = preload("uid://e0yfifw5xtxu")


@export var columnas:int
@export_enum(
	"mariposas",
	"plantas"
) var tipo_de_boton:int

@onready var lista_mariposas:Array = Dios.bd_interna["orden_inportancia_mariposas"]
@onready var lista_plantas:Array = Dios.bd_interna["orden_planta"]
@onready var filas: VBoxContainer = $MarginContainer/Filas

var mariposa_seleccionada:String
var planta_seleccionada:String

#func _ready() -> void:
	#_crear_accesos()

func _crear_accesos():
	var lista_items:Array
	if tipo_de_boton == 0:
		if lista_mariposas.is_empty():
			print("lista vacia")
			return
		else: lista_items = lista_mariposas.duplicate()
			
	else:
		if lista_plantas.is_empty():
			print("lista vacia")
			return
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
		if tipo_de_boton == 0:
			boton_cont.boton.pressed.connect(_seleccionar_mariposa.bind(item))
			desbloqueado = Dios.bd_externa["progreso_mariposas"][item]
			ruta_textura = Dios.bd_interna["mariposas"][item]["textura_libro"]
			#if !desbloqueado.is_empty():
				#nuevo_boton_mariposa.texture_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)
			#else :
				#nuevo_boton_mariposa.texture_rect.modulate = Color(0.0, 0.0, 0.0, 1.0)
		else:
			boton_cont.boton.pressed.connect(_seleccionar_planta.bind(item))
			#desbloqueado = Dios.bd_externa["progreso_plantas"][item]
			ruta_textura = Dios.bd_interna["plantas"][item]["imagen_libro"]

		var textura = load(ruta_textura)
		#print(ruta_textura)
		#print(tipo_de_boton)
		boton_cont.boton.texture_normal = textura
		#print(desbloqueado)
			
func _seleccionar_mariposa(mariposa:String):
	mariposa_seleccionada = mariposa
	emit_signal("pasando_pagina",mariposa)
	print("llendooo a "+mariposa)

func _seleccionar_planta(planta:String):
	planta_seleccionada = planta
	emit_signal("pasando_pagina",planta)
	print("llendooo a "+planta)
