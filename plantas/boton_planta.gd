extends TextureButton
class_name BotonPlanta
signal pedido_de_planta(recurso_planta, emisor)

@onready var dibujo: Node2D = $Dibujo
@onready var imagen_etiqueta: NinePatchRect = $etiqueta_hover
@onready var etiqueta: Label = $etiqueta_hover/Label
@export var recurso: RecursoPlanta

func _ready() -> void:
	etiqueta.text = "       " + recurso.nombre_planta
	var ancho_texto = etiqueta.get_combined_minimum_size().x
	imagen_etiqueta.size.x = ancho_texto + 10
	estructurar_planta()

func _al_presionar():
	pedido_de_planta.emit(recurso, self)
	hide()

func estructurar_planta():
	for modulo in recurso.estructura:
		var imagen: Sprite2D = Sprite2D.new()
		imagen.texture = recurso.textura # <--- FALTA ESTA LÍNEA
		imagen.position = Vector2(recurso.tamaño_de_tiles * modulo.x, recurso.tamaño_de_tiles * modulo.y)
		dibujo.add_child(imagen)
	redimensionar_icono_boton()

func redimensionar_icono_boton():
	var tamano_maximo = 0.0
	for casilla in recurso.estructura:
		if tamano_maximo < absf(casilla.y):
			tamano_maximo = absf(casilla.y)
	dibujo.position += Vector2(16,16)
	dibujo.scale /= (tamano_maximo + 1.0)

func mostrar_requisitos(): imagen_etiqueta.show()
func ocultar_requisitos(): imagen_etiqueta.hide()
func mostrar_imagen(): show()
