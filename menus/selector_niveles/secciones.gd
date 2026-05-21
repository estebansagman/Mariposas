extends TextureRect
class_name Sector

var numero_de_seccion: int
@onready var estrella: TextureRect = $Candado
@onready var condiciones: Label = $Condiciones

func verificar_condiciones():
	var nombre_llave = "seccion_" + str(numero_de_seccion)
	if numero_de_seccion == 1:
		condiciones.text = "" 
		hide()
		return
	var anterior = "seccion_" + str(numero_de_seccion - 1)
	var ganados = Dios.bd_externa["sectores"][anterior]["niveles_superados"]
	var requisito = Dios.bd_interna["sectores"]["seccion_" + str(numero_de_seccion)]["requisito"]
	condiciones.text = str(int(ganados)) + " / " + str(int(requisito))
	
	if Dios.bd_externa["sectores"][nombre_llave]["desbloqueo"]:
		estrella.show()
	else:
		estrella.hide()
