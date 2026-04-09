extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("comando_magico"):
		visible = !visible
		print("esto anda?")

func salid_de_juego(): #auxiliar, borrar despues
	get_tree().quit()

func borrar_bd(): #auxiliar, borrar despues
	Dios.borrar_todo()

func llenar_bd(): #auxiliar, borrar despues
	Dios.debug_completar_juego()
