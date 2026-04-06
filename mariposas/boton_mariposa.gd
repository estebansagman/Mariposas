extends TextureButton
class_name BotonMariposa

@onready var escena_general: Node2D = $"../../../.."
@onready var mariposa_escena = preload("uid://dprfbi2712evq")
@onready var textura_requisitos: Sprite2D = $requisitos
#@onready var dibujo: Node2D = $Dibujo
@onready var mariposa_objeto:Mariposa
@export var recurso:RecursoMariposa
@export var control_tablero:ControlTablero

func _ready() -> void:
	texture_normal = recurso.textura
	textura_requisitos.texture = recurso.textura_requisitos

func andando():
	print("el boton funciona")

func generar_mariposa():
	print("generando")
	mariposa_objeto = mariposa_escena.instantiate()
	mariposa_objeto.datos = recurso
	mariposa_objeto.soltando.connect(control_tablero.posicionar_mariposa) # posicionar MARIPOSA
	mariposa_objeto.seleccionado.connect(control_tablero.seleccionar_mariposa)
	mariposa_objeto.eliminando.connect(mostrar_imagen)
	#mariposa_objeto.set_id_mariposa(get_index()+1)
	escena_general.add_child(mariposa_objeto)
	control_tablero.seleccionar_mariposa(mariposa_objeto)
	hide()

func mostrar_requisitos():
	textura_requisitos.show()
	print("dentro")
func ocultar_requisitos():
	textura_requisitos.hide()

func mostrar_imagen():
	show()
