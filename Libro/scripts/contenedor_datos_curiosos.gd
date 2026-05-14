extends ScrollContainer

const TEXTO_DATO_CURIOSO = preload("uid://ca0tlk0b5ipan")
@onready var filas: VBoxContainer = $Filas
@onready var titulo: Label = $Filas/Titulo


func cargar_datos_curiosos(mariposa: String):
	var salteado=false
	for hijo in filas.get_children():
		if !salteado:
			salteado = true
			continue
		hijo.queue_free()
	var datos = Dios.bd_externa["progreso_mariposas"][mariposa]
	titulo.show()
	if datos.is_empty():
		return
	for dato in datos:
		if dato == Dios.bd_interna["mariposas"][mariposa]["dato_curioso_1"]:
			titulo.hide()
			var dato_curioso = TEXTO_DATO_CURIOSO.instantiate()
			filas.add_child(dato_curioso)
			dato_curioso.cargar_dato_curioso("1",dato)

		if dato == Dios.bd_interna["mariposas"][mariposa]["dato_curioso_2"]:
			titulo.hide()
			var dato_curioso = TEXTO_DATO_CURIOSO.instantiate()
			filas.add_child(dato_curioso)
			dato_curioso.cargar_dato_curioso("2",dato)

	#var dato_curioso = Dios.bd_interna["mariposas"][mariposa]["datos_curiosos"]
	#for clave in dato_curioso:
		#var valor = dato_curioso[clave]
		#print(clave, ": ", valor)
	#titulo.hide()
