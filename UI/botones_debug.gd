extends Control

var nivel_jugandose

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("comando_magico"):
		visible = !visible
		
func salid_de_juego():
	get_tree().quit()

func borrar_bd():
	Dios.borrar_todo()
	get_tree().reload_current_scene()
	Dios.replicar_niveles_a_user(true)

func llenar_bd():
	Dios.debug_completar_juego()
	get_tree().reload_current_scene()

func superar_nivel():
	nivel_jugandose.completar_nivel()
	nivel_jugandose.revelar_datos()
	nivel_jugandose.volver_al_Menu()

func completar_libro():
	for mariposa_id in Dios.bd_externa["progreso_mariposas"].keys():
		print("mariposa es : ",mariposa_id)
		Dios.bd_externa["progreso_mariposas"][mariposa_id] = []
		Dios.bd_externa["progreso_mariposas"][mariposa_id].append(Dios.bd_interna["mariposas"][mariposa_id]["nombre"])
		Dios.bd_externa["progreso_mariposas"][mariposa_id].append(Dios.bd_interna["mariposas"][mariposa_id]["nombre_cientifico"])
		Dios.bd_externa["progreso_mariposas"][mariposa_id].append(Dios.bd_interna["mariposas"][mariposa_id]["textura_libro"])
		Dios.bd_externa["progreso_mariposas"][mariposa_id].append(Dios.bd_interna["mariposas"][mariposa_id]["textura_oruga_libro"])
		Dios.bd_externa["progreso_mariposas"][mariposa_id].append(Dios.bd_interna["mariposas"][mariposa_id]["dato_curioso_1"])
		Dios.bd_externa["progreso_mariposas"][mariposa_id].append(Dios.bd_interna["mariposas"][mariposa_id]["dato_curioso_2"])
		#for dato in Dios.bd_interna["mariposas"][mariposa_id]["datos_curiosos"]:
			#Dios.bd_externa["progreso_mariposas"][mariposa_id].append(dato)
		Dios.guardar_bd_externa()

func borrar_progreso():
	for mariposa_id in Dios.bd_externa["progreso_mariposas"].keys():
		Dios.bd_externa["progreso_mariposas"][mariposa_id] = []
	Dios.guardar_bd_externa()	

func in_superar():
	nivel_jugandose.in_superar_nivel()

func borrar_estado_niveles():
	Dios.replicar_niveles_a_user(true)

func superar_tutoriales():
	Dios.bd_externa["sectores"]["seccion_1"]["niveles_superados"] = 2
	Dios.bd_externa["sectores"]["seccion_1"]["niveles"]["nivel_1"]["superado"] = true
	Dios.bd_externa["sectores"]["seccion_1"]["niveles"]["nivel_2"]["superado"] = true
	Dios.bd_externa["sectores"]["seccion_1"]["niveles"]["nivel_1"]["primer_entrada"] = true
	Dios.bd_externa["sectores"]["seccion_1"]["niveles"]["nivel_2"]["primer_entrada"] = true
	Dios.bd_externa["sectores"]["seccion_1"]["niveles"]["nivel_1"]["ya_fue_jugado"] = true
	Dios.bd_externa["sectores"]["seccion_1"]["niveles"]["nivel_2"]["ya_fue_jugado"] = true
	Dios.guardar_bd_externa()
	get_tree().reload_current_scene()
	
func superar_segundo_sector():
	Dios.bd_externa["sectores"]["seccion_2"]["niveles_superados"] = 2
	Dios.bd_externa["sectores"]["seccion_2"]["niveles"]["nivel_1"]["superado"] = true
	Dios.bd_externa["sectores"]["seccion_2"]["niveles"]["nivel_2"]["superado"] = true

	Dios.bd_externa["sectores"]["seccion_2"]["niveles"]["nivel_1"]["primer_entrada"] = true
	Dios.bd_externa["sectores"]["seccion_2"]["niveles"]["nivel_2"]["primer_entrada"] = true
	
	Dios.bd_externa["sectores"]["seccion_2"]["niveles"]["nivel_1"]["ya_fue_jugado"] = true
	Dios.bd_externa["sectores"]["seccion_2"]["niveles"]["nivel_2"]["ya_fue_jugado"] = true
	Dios.guardar_bd_externa()
	get_tree().reload_current_scene()
