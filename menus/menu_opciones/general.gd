extends VBoxContainer


func borrar_bd():
	Dios.borrar_todo()
	#get_tree().reload_current_scene()
	Dios.replicar_niveles_a_user(true)
