extends TextureRect
signal nivel_elejido(nivel_actual)

@export var nivel:String = "res://niveles/Nivel_Base.tscn" #Esto va a autoconstruirse con desde el contenedor central, ahora va a mano
var indice:int
@onready var etiqueta: Label = $Nivel
@onready var color_rect: ColorRect = $ColorRect
var seleccionado = false

func _process(delta: float) -> void:
	if seleccionado and Input.is_action_pressed("aceptar"):
		color_rect.hide()
		deseleccionar()

func dar_indice(factor):
	indice = get_index()+1 + (4 * factor)
	etiqueta.text = "Nivel "+str(indice)

func seleccionar():
	emit_signal("nivel_elejido",nivel)
	color_rect.show()
	seleccionado= true
	
func deseleccionar():
	seleccionado =false
