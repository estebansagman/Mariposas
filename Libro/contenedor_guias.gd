extends HBoxContainer
var nombre:String
@onready var boton: TextureButton = $AspectRatioContainer/Boton
@onready var titulo: TextureRect = $AspectRatioContainer/Boton/Control/Titulo

func prueba():
	boton.texture_normal
