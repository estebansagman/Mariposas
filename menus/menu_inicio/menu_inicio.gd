extends Control
@onready var SELECTOR_NIVELES:String = "res://menus/selector_niveles/selector_niveles.tscn"

func _ready() -> void:
	Dios.gestionar_bd_externa()
	Dios.equiparar_bases_directo()
	Dios.replicar_niveles_a_user()

func menu_nivel():
	get_tree().change_scene_to_file(SELECTOR_NIVELES)
func salir():get_tree().quit()
func opciones():pass
