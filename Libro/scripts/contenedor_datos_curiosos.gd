extends ScrollContainer

const TEXTO_DATO_CURIOSO = preload("uid://ca0tlk0b5ipan")
@onready var filas: VBoxContainer = $Filas
@onready var titulo: Label = $Filas/Titulo


func cargar_datos_curiosos(mariposa: String):
	var datos = Dios.bd_externa["progreso_mariposas"][mariposa]
	titulo.show()
	if datos.is_empty():
		return
	for dato in datos:
		if dato in Dios.bd_interna["mariposas"][mariposa]["datos_curiosos"]:
			titulo.hide()
			Dios.bd_externa["progreso_mariposas"][mariposa]
	#var dato_curioso = Dios.bd_interna["mariposas"][mariposa]["datos_curiosos"]
	#for clave in dato_curioso:
		#var valor = dato_curioso[clave]
		#print(clave, ": ", valor)
	#titulo.hide()
		
