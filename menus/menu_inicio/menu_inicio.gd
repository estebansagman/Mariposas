extends Control
@onready var SELECTOR_NIVELES:String = "res://VFX/escena_transicion.tscn"

func menu_nivel():
	get_tree().change_scene_to_file(SELECTOR_NIVELES)
func salir():get_tree().quit()
func opciones():pass
