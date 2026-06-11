extends TextureRect
signal nivel_elejido(nivel_actual, indice, sector)

@export var activar_siempre:bool
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
	#var primer_entrada = Dios.bd_externa["sectores"]["seccion_"+str(sector)]["niveles"]["nivel_"+str(indice)]["primer_entrada"]
	var ruta_incognita = "res://menus/selector_niveles/imagenes/nivel-bloqueado.png"
	if Dios.bd_externa["sectores"]["seccion_"+str(sector)]["desbloqueo"]:

		var t = create_tween()
		if "primer_entrada" or activar_siempre:
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
	var ruta_actual = "res://niveles/niveles/sector_"+ str(sector) +"/Nivel_" + str(indice) + ".tscn"
	if ResourceLoader.exists(ruta_actual):
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ZOOM)
		emit_signal("nivel_elejido", ruta_actual, indice, sector)
	else:
		emit_signal("nivel_elejido","res://niveles/Nivel_Base.tscn",indice)


	
