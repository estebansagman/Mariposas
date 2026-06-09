extends HBoxContainer
class_name BotonMariposaH

var indice:int
@onready var mariposa_escena = preload("uid://dprfbi2712evq")
@onready var mariposa_objeto:Mariposa
@export var key_mariposa:String 


@onready var boton_mariposa: TextureButton = $BotoMariposa
@onready var requerimientos: Label = $BotoMariposa/ContenedorEtiquetas/Etiqueta
@onready var contenedor_etiquetas: VBoxContainer = $BotoMariposa/ContenedorEtiquetas

func _ready() -> void:
	var ruta_textura = Dios.bd_interna["mariposas"][key_mariposa]["textura_juego"]
	var textura_cargada = load(ruta_textura)
	
	boton_mariposa.texture_normal = textura_cargada
	
	var offset_y = 0
	
	for requisito in Dios.bd_interna["mariposas"][key_mariposa]["plantas_requeridas"]:
		var nueva_etiqueta = requerimientos.duplicate()
		contenedor_etiquetas.add_child(nueva_etiqueta)
		requerimientos.text = str(requisito)
		requerimientos.show()
		#nueva_etiqueta.size.x = label.get_combined_minimum_size().x + 10
		#nueva_etiqueta.position.y = offset_y
		#offset_y += nueva_etiqueta.size.y + 2
	#contenedor_etiquetas.hide()
	indice=get_index()+1

func mostrar_requisitos(): 
	contenedor_etiquetas.show()
	print("AAAAAAAAAAAAA")
func ocultar_requisitos(): 
	contenedor_etiquetas.hide()
	print("AAAAAAAAAAAAA")
func mostrar_imagen(): show()
