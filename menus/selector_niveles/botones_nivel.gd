extends TextureRect
signal nivel_elejido(nivel_actual, indice, sector)

#@export var nivel:String = "res://niveles/Nivel_Base.tscn" #Esto va a autoconstruirse con desde el contenedor central, ahora va a mano

@export var indice:int
@export var sector:int
@onready var etiqueta: Label = $Nivel
@onready var color_rect: ColorRect = $ColorRect
var seleccionado = false
var desbloqueado = false
@onready var puntaje: sistema_puntaje = $Puntaje

func _process(delta: float) -> void:
	if seleccionado and Input.is_action_pressed("aceptar") and desbloqueado:
		color_rect.hide()
		deseleccionar()
		
func _ready() -> void:
	etiqueta.text = "Nivel "+str(indice)

func dar_indice():
	etiqueta.text = "Nivel " + str(indice)
	if Dios.esta_desbloqueado(sector, indice): 
		modulate = Color(1, 1, 1, 1)
		desbloqueado = true
	else:
		modulate = Color(0.2, 0.2, 0.2, 1)
		desbloqueado = false
	var esta_ganado = Dios.config.get_value("Completados", str(sector) + "_" + str(indice), false)
	puntaje.actualizar_visual(esta_ganado)

func seleccionar():
	var ruta_actual = "res://niveles/niveles/sector_"+ str(sector) +"/Nivel_" + str(indice) + ".tscn"
	if ResourceLoader.exists(ruta_actual):
		emit_signal("nivel_elejido", ruta_actual, indice, sector)
		color_rect.show()
		seleccionado= true
	else:
		emit_signal("nivel_elejido","res://niveles/Nivel_Base.tscn",indice)
		color_rect.show()
		seleccionado= true
	
func deseleccionar():
	seleccionado =false
