extends TextureButton
class_name BotonMariposa

var indice:int
@onready var mariposa_escena = preload("uid://dprfbi2712evq")
@onready var mariposa_objeto:Mariposa
@export var key_mariposa:String 
@onready var texture_rect: TextureRect = $TextureRect

@onready var imagen_etiqueta_1: NinePatchRect = $EtiquetaRequisitos
@onready var requisitos: Control = $requisitos

func _ready() -> void:
	var ruta_textura = Dios.bd_interna["mariposas"][key_mariposa]["textura_juego"]
	var textura_cargada = load(ruta_textura)
	
	texture_rect.texture = textura_cargada
	
	var offset_y = 0
	
	for requisito in Dios.bd_interna["mariposas"][key_mariposa]["plantas_requeridas"]:
		var nueva_etiqueta = imagen_etiqueta_1.duplicate()
		requisitos.add_child(nueva_etiqueta)
		var label = nueva_etiqueta.get_node("Label")
		label.text = "       " + str(requisito)
		nueva_etiqueta.size.x = label.get_combined_minimum_size().x + 10
		nueva_etiqueta.position.y = offset_y
		offset_y += nueva_etiqueta.size.y + 2
	requisitos.hide()
	imagen_etiqueta_1.hide()
	indice=get_index()+1

func mostrar_requisitos(): requisitos.show()
func ocultar_requisitos(): requisitos.hide()
func mostrar_imagen(): show()
