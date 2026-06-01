extends TextureRect

@onready var numero_dato: Label = $numero_dato
@onready var dato: Label = $Dato

func cargar_dato_curioso(numero,info):
	numero_dato.text = "dato curioso " + str(numero)
	dato.text = str(info)
