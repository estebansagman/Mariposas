extends Control

@onready var imagen: TextureRect = $MarginContainer/ContenedorGeneral/Polaroid/AspectRatioContainer/Planta
@onready var nombre_comun: Label = $MarginContainer/ContenedorGeneral/Nombres/NombreComun
@onready var nombre_cientifico: Label = $MarginContainer/ContenedorGeneral/Nombres/NombreCientifico
@onready var dato_curioso_1: RichTextLabel = $MarginContainer/ContenedorGeneral/DatosCuriosos/ScrollContainer/Contenedor/DatoCurioso

func generar_datos(especimen):
	var nombre:String = Dios.bd_interna["plantas"][especimen]["nombre_comun"]
	var nombre_cient:String = Dios.bd_interna["plantas"][especimen]["nombre_cientifico"]
	var ruta_imagen:String = Dios.bd_interna["plantas"][especimen]["imagen_libro"]
	var dato_curioso:String = Dios.bd_interna["plantas"][especimen]["dato_curioso_1"]

	nombre_comun.text = nombre
	nombre_cientifico.text = nombre_cient
	dato_curioso_1.text = dato_curioso
	imagen.texture = load(ruta_imagen)
