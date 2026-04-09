extends TextureRect
signal nivel_elejido(nivel_actual,indice)

#@export var nivel:String = "res://niveles/Nivel_Base.tscn" #Esto va a autoconstruirse con desde el contenedor central, ahora va a mano

var indice:int
@onready var etiqueta: Label = $Nivel
@onready var color_rect: ColorRect = $ColorRect
var seleccionado = false
var desbloqueado = false
@onready var puntaje: sistema_puntaje = $Puntaje

func _process(delta: float) -> void:
	if seleccionado and Input.is_action_pressed("aceptar") and desbloqueado:
		color_rect.hide()
		deseleccionar()

func dar_indice(factor):
	indice = get_index()+1 + (4 * factor)
	etiqueta.text = "Nivel "+str(indice)
	puntaje.indice = indice
	puntaje.generar_stats()
	if Dios.esta_desbloqueado(indice):
		modulate = Color(1, 1, 1, 1)
		desbloqueado = true
	else:
		modulate = Color(0.2, 0.2, 0.2, 1)
	var estrellas_viejas = Dios.obtener_estrellas(indice)
	puntaje.encendido_estrellas(estrellas_viejas)

func seleccionar():
	var ruta_actual = "res://niveles/niveles/Nivel_" + str(indice) + ".tscn"
	if ResourceLoader.exists(ruta_actual):
		emit_signal("nivel_elejido",ruta_actual,indice)
		color_rect.show()
		seleccionado= true
	else:
		emit_signal("nivel_elejido","res://niveles/Nivel_Base.tscn",indice)
		color_rect.show()
		seleccionado= true
	
	
func deseleccionar():
	seleccionado =false
