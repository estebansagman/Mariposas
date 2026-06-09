extends VBoxContainer
class_name BotonObjeto
signal pedido_de_objeto(llave_objeto:String, forma:Vector2i, emisor:BotonObjeto)

@onready var boton: TextureButton = $Boton

var key_objeto: String
#var key_estructura: String
var estructura:Array[Vector2i]
#@onready var ejemplar:String

func _ready() -> void:
	var dato_crudo = Dios.bd_interna["objetos"][key_objeto]["forma"].duplicate()
	var ruta_textura_A = Dios.bd_interna["objetos"][key_objeto]["imagen"]
	estructura = Dios.transformar_en_vector2i(dato_crudo).duplicate()
	#print("Estructura: ",estructura) ASTA ACA VAMOS BIEN
	boton.texture_normal = load(ruta_textura_A)
	boton.gui_input.connect(_on_boton_gui_input)
	
func _al_presionar():
	hide()
	pedido_de_objeto.emit(key_objeto, estructura, self)

func _on_boton_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			hide()
			pedido_de_objeto.emit(key_objeto, estructura, self)
			boton.accept_event()

func mostrar_imagen(): show()
