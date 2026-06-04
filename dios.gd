extends Node

var ruta_user = "user://BD_externa.json"
var ruta_res = "res://data/BD_externa.json"

var bd_interna: Dictionary = {}
var bd_externa: Dictionary = {}

func _ready():
	bd_interna = _cargar_archivo_json("res://data/BD_interna.json")
	gestionar_bd_externa()
	replicar_niveles_a_user()

func gestionar_bd_externa(): #a futuro pensar "gestion de usuario" se crearia recien ahi, no aca.
	if not FileAccess.file_exists(ruta_user):
		print("Primera vez: Copiando base de datos a user://")
		var dir = DirAccess.open("res://")
		dir.copy(ruta_res, ruta_user)
	bd_externa = _cargar_archivo_json(ruta_user)
func _cargar_archivo_json(ruta):
	if not FileAccess.file_exists(ruta):
		push_error("FALTA EL ARCHIVO: " + ruta)
		return {}
		
	var archivo = FileAccess.open(ruta, FileAccess.READ)
	var contenido = archivo.get_as_text()
	var datos = JSON.parse_string(contenido)
	
	if datos == null:
		push_error("Error al parsear JSON en: " + ruta)
		return {}
	return datos

func guardar_bd_externa():
	var archivo = FileAccess.open(ruta_user, FileAccess.WRITE)
	var json_string = JSON.stringify(bd_externa, "\t")
	archivo.store_string(json_string)
	archivo.close()
	print("Progreso guardado")
func transformar_en_vector2i(lista_cruda: Array) -> Array[Vector2i]:
	var nueva_lista: Array[Vector2i] = []
	for punto in lista_cruda:
		var x = int(round(punto[0])) 
		var y = int(round(punto[1]))
		nueva_lista.append(Vector2i(x, y))
	return nueva_lista

func replicar_niveles_a_user(forzar_pisado: bool = false):
	var sectores = [1, 2, 3]
	var niveles_por_sector = 4 
	
	for s in sectores:
		var texto_sector = "sector_" + str(s)
		var carpeta_res = "res://niveles/niveles/" + texto_sector + "/"
		var carpeta_user = "user://niveles/niveles/" + texto_sector + "/"
		
		if not DirAccess.dir_exists_absolute(carpeta_user):
			DirAccess.make_dir_recursive_absolute(carpeta_user)
			
		for n in range(1, niveles_por_sector + 1):
			var texto_nivel = "Nivel_" + str(n) + ".cfg"
			var ruta_origen = carpeta_res + texto_nivel
			var ruta_destino = carpeta_user + texto_nivel
			
			if FileAccess.file_exists(ruta_origen):
				if forzar_pisado or not FileAccess.file_exists(ruta_destino):
					DirAccess.copy_absolute(ruta_origen, ruta_destino)
					print("Copiado/Pisado: ", texto_sector, " -> ", texto_nivel)

func borrar_todo():
	var dir = DirAccess.open("res://")
	dir.copy(ruta_res, ruta_user)
	bd_externa = _cargar_archivo_json(ruta_user)
	guardar_bd_externa()

func debug_completar_juego():
	for s_id in bd_externa["sectores"].keys():
		bd_externa["sectores"][s_id]["desbloqueo"] = true
		if bd_externa["sectores"][s_id].has("niveles"):
			for n_id in bd_externa["sectores"][s_id]["niveles"].keys():
				bd_externa["sectores"][s_id]["niveles"][n_id]["superado"] = true
				
	guardar_bd_externa()
