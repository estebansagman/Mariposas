extends VBoxContainer
class_name BotonPlanta
signal pedido_de_planta(llave_planta:String,llave_estructura,forma, emisor, ejemplar_planta)

@onready var boton: TextureButton = $Boton
@onready var imagen_etiqueta: NinePatchRect = $Boton/etiqueta_hover
@onready var etiqueta: Label = $Boton/etiqueta_hover/Label

var key_planta: String
var key_estructura:String
var estructura:Array[Vector2i]
@onready var ejemplar:String

func _ready() -> void:
	var dato_crudo = Dios.bd_interna["plantas"][key_planta]["forma"][key_estructura].duplicate()
	estructura = Dios.transformar_en_vector2i(dato_crudo)
	etiqueta.text = "       " + Dios.bd_interna["plantas"][key_planta]["nombre_comun"]
	var ancho_texto = etiqueta.get_combined_minimum_size().x
	imagen_etiqueta.size.x = ancho_texto + 10
	estructurar_planta_boton()
	boton.gui_input.connect(_on_boton_gui_input)
	
func _al_presionar():
	#AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLANTA_PICKUP)
	hide()
	pedido_de_planta.emit(key_planta, key_estructura, estructura, self, ejemplar)

func _on_boton_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			hide()
			pedido_de_planta.emit(key_planta, key_estructura, estructura, self, ejemplar)
			boton.accept_event()

func estructurar_planta_boton():
	var ruta_textura_A = Dios.bd_interna["plantas"][key_planta]["imagen_catalogo"][0]
	var ruta_textura_B = Dios.bd_interna["plantas"][key_planta]["imagen_catalogo"][1]
	if key_estructura == "A":
		boton.texture_normal = load(ruta_textura_A)
	elif key_estructura == "B":
		boton.texture_normal = load(ruta_textura_B)

func mostrar_requisitos(): imagen_etiqueta.show()
func ocultar_requisitos(): imagen_etiqueta.hide()
func mostrar_imagen(): show()
