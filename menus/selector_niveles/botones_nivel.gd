extends TextureRect
signal nivel_elejido(nivel_actual, indice, sector,reemplazar)
signal ubicar(global_position)

var activar_siempre:bool = false
@export var indice:int
@export var sector:int
@onready var etiqueta: Label = $Nivel
@export var puntaje: sistema_puntaje
@onready var imagen_nivel: TextureRect = $ImagenNivel


func dar_indice():
	etiqueta.text = "Nivel " + str(indice)
	var sectores = Dios.bd_externa.get("sectores", {})
	var datos_sector = sectores.get("seccion_" + str(sector), {})
	var nivel_estado = Dios.bd_externa["sectores"]["seccion_"+str(sector)]["niveles"]["nivel_"+str(indice)]["superado"]
	var ruta_imagen = Dios.bd_interna["sectores"]["seccion_"+str(sector)]["niveles"]["nivel_"+str(indice)]["imagen"]
	var primer_entrada = Dios.bd_externa["sectores"]["seccion_"+str(sector)]["niveles"]["nivel_"+str(indice)]["primer_entrada"]
	var ruta_incognita = "res://menus/selector_niveles/imagenes/nivel-bloqueado.png"
	if Dios.bd_externa["sectores"]["seccion_"+str(sector)]["desbloqueo"]:

		var t = create_tween()
		if primer_entrada or activar_siempre:
			Dios.bd_externa["sectores"]["seccion_"+str(sector)]["niveles"]["nivel_"+str(indice)]["primer_entrada"] = false
			Dios.guardar_bd_externa()
			#var t = create_tween()
			t.tween_method(
			func(value): imagen_nivel.material.set_shader_parameter("dissolve_value", value),  
			  0.0,  # Start value
			  1.0,  # End value
			  2     # Duration
			);
		else:
			t.tween_method(
			func(value): imagen_nivel.material.set_shader_parameter("dissolve_value", value),  
			  0.0,  # Start value
			  1.0,  # End value
			  0     # Duration
			);

		#imagen_nivel.material.set_shader_parameter("dissolve_value",1)
		
		if ruta_imagen != "" and ResourceLoader.exists(ruta_imagen):
			imagen_nivel.texture = load(ruta_imagen)
		else:
			#imagen_nivel.texture = null
			imagen_nivel.texture = preload("uid://c1tp7pqe622b5")

	else:
		imagen_nivel.material.set_shader_parameter("dissolve_value",0)
	puntaje.actualizar_visual(nivel_estado)

func seleccionar():
	if Dios.bd_externa["sectores"]["seccion_"+str(sector)]["desbloqueo"]:
		iniciar_transicion()
	else:
		emit_signal("nivel_elejido",null,null,null,null)
		pass

func reconocer_nivel(reemplazar)->void:
	var ruta_actual = "res://niveles/niveles/sector_"+ str(sector) +"/Nivel_" + str(indice) + ".tscn"
	if ResourceLoader.exists(ruta_actual):
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ZOOM)
		emit_signal("nivel_elejido", ruta_actual, indice, sector,reemplazar)
	else:
		emit_signal("nivel_elejido","res://niveles/Nivel_Base.tscn",indice,reemplazar)


func iniciar_transicion()->void:
	var escena_transicion = get_tree().current_scene
	var menu = get_tree().current_scene.find_child("MenuNiveles",true,false)
	var subview = escena_transicion.subview
	if !menu:
		printerr("No se encontró el MenuNiveles")
		return
	menu.reparent(subview,true)
	subview.move_child(menu,0)
	
	#get_tree().paused = true
	reconocer_nivel(false)
	
	var polaroid = escena_transicion.polaroid
	var t = create_tween()
	var dur = 0.8 #1
	polaroid.global_position = self.global_position
	t.tween_property(polaroid,"scale",Vector2.ONE*26,dur).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	await t.finished
	reconocer_nivel(true)
	

#func iniciar_transicion()->void:
	#var ESCENA_TRANSICION = preload("uid://b4cdao7hnr5f7")
	#var pantalla_inicial = get_tree().current_scene.duplicate()
	#print(get_tree().current_scene)
	#ESCENA_TRANSICION.set_meta("escena_inicial",pantalla_inicial)
	#get_tree().change_scene_to_packed(ESCENA_TRANSICION)

"""
func iniciar_transicion()->void:
	const ESCENA_TRANSICION = preload("uid://b4cdao7hnr5f7")
	var transicion = ESCENA_TRANSICION.instantiate()
	get_tree().current_scene.get_parent().add_child(transicion,true)
	transicion.polaroid_pos = global_position
	print(get_tree().current_scene)
	get_tree().current_scene.reparent(transicion.viewport,true)
	duplicar(global_position,transicion.viewport)
	reconocer_nivel(transicion.camara)

func duplicar(ubicacion,parent)->void:
	const VERDEPURO = preload("uid://cc4keaggst30f")
	var mascara:TextureRect = self.duplicate()
	#var panel = get_tree().current_scene.get_child(-1)
	#var mn = panel.get_child(-1)
	var t = create_tween()

	#panel.remove_child(mn)
	#panel.get_child(0).add_child(mn)
	#panel.get_child(0).add_child(mascara,true,Node.INTERNAL_MODE_BACK)
	parent.add_child(mascara)
	
	mascara.scale = Vector2(1.72,1.72)
	mascara.global_position = ubicacion
	mascara.get_child(2).texture = VERDEPURO
	
	t.tween_property(mascara,"scale",Vector2.ONE*25,1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
"""
