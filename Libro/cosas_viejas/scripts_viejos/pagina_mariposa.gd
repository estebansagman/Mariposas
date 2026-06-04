extends Control

@onready var requisitos: Label = $HojaIzquierda/Requisitos
@onready var nombre_comun: Label = $HojaIzquierda/NombreComun
@onready var mariposa_imagen: TextureRect = $HojaIzquierda/Mariposa

@onready var oruga_imagen: TextureRect = $HojaDerecha/Oruga
@onready var nombre_cientifico: Label = $HojaDerecha/NombreCientifico
@onready var datos_curiosos: ScrollContainer = $HojaDerecha/DatosCuriosos


var mariposa:String
var oculto:String = "???"

func cargar_datos(key_mariposa):
	mariposa = key_mariposa
	var desbloqueado = Dios.bd_externa["progreso_mariposas"][mariposa]
	
	cargar_nombre(desbloqueado)
	cargar_imagen_mariposa(desbloqueado)
	cargar_requisitos()
	
	cargar_imagen_oruga(desbloqueado)
	cargar_nombre_cientifico(desbloqueado)
	cargar_datos_curioso()

func cargar_nombre(lista_desbloqueo):
	var nombre = Dios.bd_interna["mariposas"][mariposa]["nombre"]
	if nombre in lista_desbloqueo:
		nombre_comun.text = nombre
	else :
		nombre_comun.text = oculto

func cargar_nombre_cientifico(lista_desbloqueo):
	var key_nombre_cientifico = Dios.bd_interna["mariposas"][mariposa]["nombre_cientifico"]
	if key_nombre_cientifico in lista_desbloqueo:
		nombre_cientifico.text = key_nombre_cientifico
	else :
		nombre_cientifico.text = oculto

func cargar_imagen_mariposa(lista_desbloqueo):
	print("Llega a la funcion")
	var textura_libro = Dios.bd_interna["mariposas"][mariposa]["textura_libro"]
	if textura_libro in lista_desbloqueo:
		mariposa_imagen.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else :
		mariposa_imagen.modulate = Color(0.0, 0.0, 0.0, 1.0)

func cargar_imagen_oruga(lista_desbloqueo):
	var textura_oruga = Dios.bd_interna["mariposas"][mariposa]["textura_oruga_libro"]
	if textura_oruga in lista_desbloqueo:
		oruga_imagen.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else :
		oruga_imagen.modulate = Color(0.0, 0.0, 0.0, 1.0)

func cargar_requisitos():
	requisitos.crear_requisitos(mariposa)
func cargar_datos_curioso():
	datos_curiosos.cargar_datos_curiosos(mariposa)
