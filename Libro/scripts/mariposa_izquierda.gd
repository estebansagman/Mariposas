extends Control

const POLAROID_VACIA = preload("uid://cbqhid1akseog")

@onready var imagen: TextureRect = $MarginContainer/ContenedorGeneral/AspectRatioContainer/Imagen
@onready var nombre_comun: Label = $MarginContainer/ContenedorGeneral/Titulos/Nombres/NombreComun
@onready var nombre_cientifico: Label = $MarginContainer/ContenedorGeneral/NombreCientifico
@onready var planta_1: TextureRect = $MarginContainer/ContenedorGeneral/Titulos/PlantasChicas/Imagenes/Planta1
@onready var planta_2: TextureRect = $MarginContainer/ContenedorGeneral/Titulos/PlantasChicas/Imagenes/Planta2
@onready var planta_3: TextureRect = $MarginContainer/ContenedorGeneral/Titulos/PlantasChicas/Imagenes/Planta3
@onready var oruga: TextureRect = $MarginContainer/ContenedorGeneral/Titulos/OrugaChica/Oruga
@onready var dato_curioso_1: RichTextLabel = $MarginContainer/ContenedorGeneral/DatosCuriosos/ScrollContainer/VBoxContainer/DatoCurioso1

var oculto:String = "???"

func generar_datos(especimen):
	var nombre:String = Dios.bd_interna["mariposas"][especimen]["nombre"]
	var nombre_cient:String = Dios.bd_interna["mariposas"][especimen]["nombre_cientifico"]
	var ruta_imagen:String = Dios.bd_interna["mariposas"][especimen]["textura_libro"]
	var icono_oruga:String = Dios.bd_interna["mariposas"][especimen]["icono_oruga"]
	var textura_oruga_libro:String = Dios.bd_interna["mariposas"][especimen]["textura_oruga_libro"]
	var plantas_necesarias:Array = Dios.bd_interna["mariposas"][especimen]["plantas_requeridas"].duplicate()
	var dato_curioso:String = Dios.bd_interna["mariposas"][especimen]["dato_curioso_1"]
	var texturas_iconos_planta:Array[TextureRect] = [planta_1,planta_2,planta_3]
	
	var lista_desbloqueo = Dios.bd_externa["progreso_mariposas"][especimen]
	planta_3.hide()
	
	cargar_imagen_mariposa(lista_desbloqueo,ruta_imagen,POLAROID_VACIA)
	cargar_nombre(lista_desbloqueo,nombre)
	cargar_nombre_cientifico(lista_desbloqueo,nombre_cient)
	cargar_dato_oculto_1(lista_desbloqueo,dato_curioso)
	cargar_icono_oruga(lista_desbloqueo,textura_oruga_libro,icono_oruga)
	cargar_iconos_planta(lista_desbloqueo,plantas_necesarias,texturas_iconos_planta)

func cargar_imagen_mariposa(lista_desbloqueo,ruta_textura,textura_bloqueo):
	if ruta_textura in lista_desbloqueo:
		imagen.texture = load(ruta_textura)
	else :
		imagen.texture = textura_bloqueo
func cargar_nombre(lista_desbloqueo,nombre):
	if nombre in lista_desbloqueo:
		nombre_comun.text = nombre
	else :
		nombre_comun.text = oculto
func cargar_nombre_cientifico(lista_desbloqueo,key_nombre_cientifico):
	if key_nombre_cientifico in lista_desbloqueo:
		nombre_cientifico.text = key_nombre_cientifico
	else :
		nombre_cientifico.text = oculto
func cargar_dato_oculto_1(lista_desbloqueo,dato_curioso):
	if dato_curioso in lista_desbloqueo:
		dato_curioso_1.text = dato_curioso
	else :
		dato_curioso_1.text = oculto
func cargar_icono_oruga(lista_desbloqueo,oruga_textura,icono):
	if oruga_textura in lista_desbloqueo:
		oruga.texture = load(icono)
		oruga.show()
	else :
		oruga.hide()
func cargar_iconos_planta(lista_desbloqueo,plantas_necesarias,texturas):
	for i in range(plantas_necesarias.size()):
		var planta = plantas_necesarias[i]
		#if planta in lista_desbloqueo:
		var ruta_imagen_icono = Dios.bd_interna["plantas"][planta]["icono"]
		texturas[i].texture = load(ruta_imagen_icono)
		texturas[i].show()
		#else:
			#texturas[i].hide()
