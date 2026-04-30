extends TextureButton
class_name BotonPlanta
signal pedido_de_planta(llave_planta:String,llave_estructura,forma, emisor)

@onready var dibujo: Node2D = $Dibujo
@onready var imagen_etiqueta: NinePatchRect = $etiqueta_hover
@onready var etiqueta: Label = $etiqueta_hover/Label
var key_planta: String
var key_estructura:String
var estructura:Array[Vector2i]

func _ready() -> void:
	var dato_crudo = Dios.bd_interna["plantas"][key_planta]["forma"][key_estructura].duplicate()
	estructura = Dios.transformar_en_vector2i(dato_crudo)
	etiqueta.text = "       " + Dios.bd_interna["plantas"][key_planta]["nombre_comun"]
	var ancho_texto = etiqueta.get_combined_minimum_size().x
	imagen_etiqueta.size.x = ancho_texto + 10
	estructurar_planta_boton()

func _al_presionar():
	pedido_de_planta.emit(key_planta,key_estructura,estructura, self)
	hide()

func estructurar_planta_boton():
	for modulo in estructura:
		var imagen: Sprite2D = Sprite2D.new()
		var ruta_textura = Dios.bd_interna["plantas"][key_planta]["imagen_catalogo"]
		var textura_cargada = load(ruta_textura)
		imagen.texture = textura_cargada
		imagen.position = Vector2(64 * modulo.x, 64 * modulo.y)
		dibujo.add_child(imagen)
	redimensionar_icono_boton()

func redimensionar_icono_boton():
	var tamano_maximo = 0.0
	for casilla in estructura:
		if tamano_maximo < absf(casilla.y):
			tamano_maximo = absf(casilla.y)
	dibujo.position += Vector2(16,16)
	dibujo.scale /= (tamano_maximo + 1.0)

func mostrar_requisitos(): imagen_etiqueta.show()
func ocultar_requisitos(): imagen_etiqueta.hide()
func mostrar_imagen(): show()
