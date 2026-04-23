extends TextureButton
class_name BotonMariposa

#@onready var escena_general: Node2D = $"../../../.."
var indice:int
@onready var mariposa_escena = preload("uid://dprfbi2712evq")
@onready var mariposa_objeto:Mariposa
@export var recurso:RecursoMariposa
#@export var control_tablero:ControlTablero
@onready var texture_rect: TextureRect = $TextureRect

@onready var imagen_etiqueta_1: NinePatchRect = $etiqueta_hover
@onready var etiqueta_1: Label = $etiqueta_hover/Label
@onready var requisitos: Control = $requisitos


func _ready() -> void:
	texture_rect.texture = recurso.textura
	
	var offset_y = 0
	
	for requisito in recurso.requisitos:
		var nueva_etiqueta = imagen_etiqueta_1.duplicate()
		requisitos.add_child(nueva_etiqueta)
		var label = nueva_etiqueta.get_node("Label")
		label.text = "       " + Dios.nombre_especies[requisito]
		nueva_etiqueta.size.x = label.get_combined_minimum_size().x + 10
		nueva_etiqueta.position.y = offset_y
		offset_y += nueva_etiqueta.size.y + 2
	requisitos.hide()
	imagen_etiqueta_1.hide()
	indice=get_index()+1
	print("mi incide es: ",indice)


func andando():
	print("el boton funciona")

#func generar_mariposa():
	#print("generando")
	#mariposa_objeto = mariposa_escena.instantiate()
	#mariposa_objeto.datos = recurso
	#mariposa_objeto.soltando.connect(control_tablero.posicionar_mariposa) # posicionar MARIPOSA
	#mariposa_objeto.seleccionado.connect(control_tablero.seleccionar_mariposa)
	#mariposa_objeto.eliminando.connect(mostrar_imagen)
	##mariposa_objeto.set_id_mariposa(get_index()+1)
	#escena_general.add_child(mariposa_objeto)
	#control_tablero.seleccionar_mariposa(mariposa_objeto)
	#hide()

func mostrar_requisitos(): requisitos.show()
func ocultar_requisitos(): requisitos.hide()
func mostrar_imagen(): show()
