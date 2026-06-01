extends TextureRect

@onready var etiqueta_hover: NinePatchRect = $etiqueta_hover
@onready var label: Label = $etiqueta_hover/Label

func acomodar_tamano(requisito:String):
	print(requisito)
	label.text = "       " + requisito
	etiqueta_hover.size.x = label.get_combined_minimum_size().x + 10
