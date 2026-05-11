extends TextureRect
signal nivel_elejido(nivel_actual, indice, sector)

@export var indice:int
@export var sector:int
@onready var etiqueta: Label = $Nivel
@export var puntaje: sistema_puntaje

func dar_indice():
	etiqueta.text = "Nivel " + str(indice)
	var sectores = Dios.bd_externa.get("sectores", {})
	var datos_sector = sectores.get("seccion_" + str(sector), {})
	var nivel_estado = Dios.bd_externa["sectores"]["seccion_"+str(sector)]["niveles"]["nivel_"+str(indice)]["superado"]
	if Dios.bd_externa["sectores"]["seccion_"+str(sector)]["desbloqueo"]:
		modulate = Color(1, 1, 1, 1)
		puntaje.actualizar_visual(nivel_estado)
	else:
		modulate = Color(0.4, 0.4, 0.4, 1)
	


func seleccionar():
	var ruta_actual = "res://niveles/niveles/sector_"+ str(sector) +"/Nivel_" + str(indice) + ".tscn"
	if ResourceLoader.exists(ruta_actual):
		emit_signal("nivel_elejido", ruta_actual, indice, sector)
	else:
		emit_signal("nivel_elejido","res://niveles/Nivel_Base.tscn",indice)


	
