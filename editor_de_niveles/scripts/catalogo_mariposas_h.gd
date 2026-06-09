extends VBoxContainer
class_name CatalogoMariposasH

#const BOTON_MARIPOSA = preload("uid://6fvergr40whw")
const BOTON_MARIPOSA_H = preload("uid://6s0ccmss67od")


var mariposas_en_Juego:Array[Mariposa]
var keys_mariposas:Array[String]

func iniciar_catalogo(key_mariposas:Array[String]):
	keys_mariposas = key_mariposas.duplicate()
	_crear_catalogo()
	await get_tree().process_frame

func _crear_catalogo():
	for key_mariposa in keys_mariposas:
		var nuevo_boton_mariposa:BotonMariposaH = BOTON_MARIPOSA_H.instantiate()
		nuevo_boton_mariposa.key_mariposa = key_mariposa
		add_child(nuevo_boton_mariposa)
