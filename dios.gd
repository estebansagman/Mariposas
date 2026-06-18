extends Node

var ruta_user = "user://BD_externa.json"
var ruta_res = "res://data/BD_externa.json"

var sector_actual: int
var nivel_actual: int

var bd_interna: Dictionary = {}
var bd_externa: Dictionary = {}
#var bd_interna_externa: Dictionary = {}

var mostrar_notif: bool

func _ready():
	bd_interna = _cargar_archivo_json("res://data/BD_interna.json")
	gestionar_bd_externa()
	replicar_niveles_a_user()
	comparar_version_y_actualizar()
	
	_configurar_cursores_del_guante()

func _configurar_cursores_del_guante() -> void:
	var mano_abierta = load("res://UI/imagenes/manito-abierta_chica.png")
	var mano_apuntar = load("res://UI/imagenes/manito-apuntar_chica.png")
	var mano_grab    = load("res://UI/imagenes/manito-grab_chica.png")
	
	Input.set_custom_mouse_cursor(mano_abierta, Input.CURSOR_POINTING_HAND, Vector2(16, 16))
	Input.set_custom_mouse_cursor(mano_apuntar, Input.CURSOR_ARROW, Vector2(5, 5))
	Input.set_custom_mouse_cursor(mano_grab, Input.CURSOR_MOVE, Vector2(16, 16))
	
	get_tree().node_added.connect(func(nodo: Node):
		if nodo is BaseButton or nodo is TextureButton:
			nodo.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	)


func cursor_mano_abierta() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func cursor_mano_apuntar() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func cursor_mano_cerrada() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_MOVE)


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

func comparar_version_y_actualizar():
	var molde_original = _cargar_archivo_json(ruta_res)
	var version_local = molde_original["version"]
	var version_user = bd_externa["version"]
	var las_versiones_son_distintas:bool = version_local != version_user
	if las_versiones_son_distintas:
		replicar_niveles_a_user(true)
		bd_externa["version"] = version_local
		guardar_bd_externa()
		
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
func equiparar_bases_directo() -> void:
	var molde_original = _cargar_archivo_json(ruta_res)
	if molde_original.is_empty():
		push_error("No se pudo cargar el molde original para equiparar.")
		return
	if bd_externa.is_empty():
		bd_externa = molde_original.duplicate(true)
		print("Base externa vacía, restaurada desde el molde.")
		return
	_fusionar_diccionarios(molde_original, bd_externa)
	guardar_bd_externa()
func _fusionar_diccionarios(molde: Dictionary, jugador: Dictionary) -> void:
	for clave in molde:
		if not jugador.has(clave):
			if molde[clave] is Dictionary:
				jugador[clave] = molde[clave].duplicate(true)
			elif molde[clave] is Array:
				jugador[clave] = molde[clave].duplicate()
			else:
				jugador[clave] = molde[clave]
			print(" -> Parche aplicado en BD_externa: Se agregó la clave: ", clave)
		elif molde[clave] is Dictionary and jugador[clave] is Dictionary:
			_fusionar_diccionarios(molde[clave], jugador[clave])
func otorgar_progreso_mariposa(mariposa_id: String) -> void:
	if not bd_externa["progreso_mariposas"].has(mariposa_id):
		bd_externa["progreso_mariposas"][mariposa_id] = []
		
	var progreso_actual: Array = bd_externa["progreso_mariposas"][mariposa_id]
	var data_interna = bd_interna["mariposas"][mariposa_id]
	
	if progreso_actual.size() == 0:
		progreso_actual.append(data_interna["nombre"])
		progreso_actual.append(data_interna["textura_libro"])
		print("-> ", mariposa_id, ": Desbloqueada Etapa 1 (Nombre e Imagen)")
		return
		
	if progreso_actual.size() == 2:
		progreso_actual.append(data_interna["nombre_cientifico"])
		progreso_actual.append(data_interna["dato_curioso_1"])
		print("-> ", mariposa_id, ": Desbloqueada Etapa 2 (Nombre Científico y Dato 1)")
		return
		
	if progreso_actual.size() == 4:
		progreso_actual.append(data_interna["textura_oruga_libro"])
		progreso_actual.append(data_interna["dato_curioso_2"])
		print("-> ", mariposa_id, ": Desbloqueada Etapa 3 (Oruga y Dato 2)")
		return
