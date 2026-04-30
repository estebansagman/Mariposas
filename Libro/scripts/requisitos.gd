extends Label

const ETIQUETA_REQUISITOS_LIBRO = preload("uid://bo5h8geremna8")
@export var columnas:int
@onready var filas: VBoxContainer = $Control/Filas

func crear_requisitos(mariposa):
	for hijo in filas.get_children():
		hijo.queue_free()
	
	var agregadas:int = 0
	var contenedor:HBoxContainer

	var requisitos:Array = Dios.bd_interna["mariposas"][mariposa]["plantas_requeridas"]
	for requisito in requisitos:
		if agregadas%columnas==0:
			contenedor = HBoxContainer.new()
			filas.add_child(contenedor)
		agregadas+=1
		var etiqueta = ETIQUETA_REQUISITOS_LIBRO.instantiate()
		contenedor.add_child(etiqueta)
		etiqueta.acomodar_tamano(str(requisito))
		
	
