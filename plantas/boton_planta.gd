extends TextureButton
class_name BotonPlanta
signal pedido_de_planta(llave_planta:String,llave_estructura,forma, emisor, ejemplar_planta)

@onready var dibujo: Node2D = $Dibujo
@onready var imagen_etiqueta: NinePatchRect = $etiqueta_hover
@onready var etiqueta: Label = $etiqueta_hover/Label
var key_planta: String
var key_estructura:String
var estructura:Array[Vector2i]
@onready var ejemplar:String
@onready var punto_aparicion: Node2D = $puntoAparicion
@onready var ejemplares: Dictionary = {
	"ceibo:A": preload("uid://crq4cgvp4qndp"),
	"ceibo:B": preload("uid://2u2bwrxrncp8"),
	"coronillo:A": preload("uid://c6pikhlq2a5qb"),
	"coronillo:B": preload("uid://cm37ht5virdhf"),
	"chilca:A": preload("uid://be5rky35pqp3r"),
	"chilca:B": preload("uid://ch5ki13fftmxd"),
	"ruda:A":preload("uid://cct63xday235l"),
	"ruda:B":preload("uid://8e1vimfhtjui"),
	"canario_rojo:A": preload("uid://d1l7h3nujrv18"),
	"canario_rojo:B":preload("uid://cbetjqdfqna7d"),
	"salvia:A":preload("uid://77r4p80njc3n"),
	"salvia:B":preload("uid://da6yggwa6opv3"),
	"ruelia:A":preload("uid://d2wxv30mfljv8"),
	"ruelia:B":preload("uid://h53ufbp7l6l3"),
	"mbrucuya:A":preload("uid://dm6ahndnly2dq"),
	"mbrucuya:B":preload("uid://cyfohd827w3ag"),
	"lantana:A":preload("uid://bfqa5wgnffhbk"),
	"lantana:B":preload("uid://cjux6woqbm3fc")
}

func _ready() -> void:
	var dato_crudo = Dios.bd_interna["plantas"][key_planta]["forma"][key_estructura].duplicate()
	estructura = Dios.transformar_en_vector2i(dato_crudo)
	etiqueta.text = "       " + Dios.bd_interna["plantas"][key_planta]["nombre_comun"]
	var ancho_texto = etiqueta.get_combined_minimum_size().x
	imagen_etiqueta.size.x = ancho_texto + 10
	estructurar_planta_boton() # pasar parametro

func _al_presionar():
	pedido_de_planta.emit(key_planta,key_estructura,estructura, self,ejemplar)
	hide()

func estructurar_planta_boton():
	var forma_superficial = ejemplares[ejemplar].instantiate()
	punto_aparicion.add_child(forma_superficial)

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
