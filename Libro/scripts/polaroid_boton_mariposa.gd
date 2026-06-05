extends HBoxContainer
class_name PolaroidBotonMariposa

const POLAROID_VACIA = preload("uid://cbqhid1akseog")
const POLAROID_HOVER = preload("uid://bgi4urjxkg8s8")

@onready var boton: TextureButton = $AspectRatioContainer/Boton
@onready var icono_planta_1: TextureRect = $"AspectRatioContainer/Boton/Control/Texto/Platas_comp/1"
@onready var icono_planta_2: TextureRect = $"AspectRatioContainer/Boton/Control/Texto/Platas_comp/2"
@onready var icono_planta_3: TextureRect = $"AspectRatioContainer/Boton/Control/Texto/Platas_comp/3"
@onready var nombre: RichTextLabel = $AspectRatioContainer/Boton/Control/Texto/CintaNombre/MarginContainer/Nombre
@onready var oruga: TextureRect = $AspectRatioContainer/Boton/Control/Texto/Oruga
@onready var textura: TextureRect = $AspectRatioContainer/Boton/TextureRect

var dato_oculto = "???"

func rellenar(mariposa):
	var nombre_mariposa: String = Dios.bd_interna["mariposas"][mariposa]["nombre"]
	var ruta_textura_normal: String = Dios.bd_interna["mariposas"][mariposa]["textura_libro"]
	var icono_oruga: String = Dios.bd_interna["mariposas"][mariposa]["icono_oruga"]
	var textura_oruga:String = Dios.bd_interna["mariposas"][mariposa]["textura_oruga_libro"]
	var plantas_necesarias: Array = Dios.bd_interna["mariposas"][mariposa]["plantas_requeridas"].duplicate()
	var iconos_plantas: Array[TextureRect] = [icono_planta_1, icono_planta_2, icono_planta_3]

	var desbloqueado = Dios.bd_externa["progreso_mariposas"][mariposa]

	cargar_datos_mariposa(desbloqueado,ruta_textura_normal,POLAROID_VACIA,plantas_necesarias,iconos_plantas)
	cargar_nombre(desbloqueado,nombre_mariposa,dato_oculto)
	cargar_icono_oruga(desbloqueado,textura_oruga,icono_oruga)

	iconos_plantas[2].hide()
	var cantidad_plantas = plantas_necesarias.size()
	
	for i in range(cantidad_plantas):
		var requisito = plantas_necesarias[i]
		var ruta_imagen_icono = Dios.bd_interna["plantas"][requisito]["icono"]
		iconos_plantas[i].texture = load(ruta_imagen_icono)
		iconos_plantas[i].show()

func cargar_datos_mariposa(lista_desbloqueo,ruta_textura,textura_bloqueo,plantas_necesarias,iconos):
	if ruta_textura in lista_desbloqueo:
		textura.texture = load(ruta_textura)
		boton.texture_hover = POLAROID_HOVER
	else :
		textura.texture = textura_bloqueo
		boton.texture_hover = null

func cargar_nombre(lista_desbloqueo,nombre_mariposa,oculto):
	if nombre_mariposa in lista_desbloqueo:
		nombre.text = nombre_mariposa
	else :
		nombre.text = oculto

func cargar_icono_oruga(lista_desbloqueo,ruta_textura,icono):
	if ruta_textura in lista_desbloqueo:
		oruga.texture = load(icono)
	else :
		oruga.hide()
