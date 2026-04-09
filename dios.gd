extends Node

const SAVE_PATH = "user://progreso.cfg"
var config = ConfigFile.new()

enum Especie {
	CEIBO,
	CORONILLO,
	CHILCA,
	RUDA,
	CANARIO_ROJO,
	SALVIA,
	RUELLIA,
	MBRUCUYA,
	LANTANA
}

func _ready():
	load_data()

func load_data():
	var error = config.load(SAVE_PATH)
	if error != OK:
		print("No hay datos previos, creando archivo nuevo.")

func guardar_estrellas(id_nivel: int, estrellas: int):
	var actuales = obtener_estrellas(id_nivel)
	if estrellas > actuales:
		config.set_value("Estrellas", str(id_nivel), estrellas)
		desbloquear_nivel(id_nivel + 1)
		config.save(SAVE_PATH)

func obtener_estrellas(id_nivel: int) -> int:
	return config.get_value("Estrellas", str(id_nivel), 0)

func desbloquear_nivel(id_nivel: int):
	config.set_value("Desbloqueados", str(id_nivel), true)
	config.save(SAVE_PATH)

func esta_desbloqueado(id_nivel: int) -> bool:
	if id_nivel == 1: return true
	return config.get_value("Desbloqueados", str(id_nivel), false)

func borrar_todo():
	var dir = DirAccess.open("user://")
	if dir.file_exists("progreso.cfg"):
		dir.remove("progreso.cfg")
	config = ConfigFile.new()
	config.set_value("Desbloqueados", "1", true)
	config.save("user://progreso.cfg")
	get_tree().reload_current_scene()

func debug_completar_juego():
	for i in range(1, 6):
		config.set_value("Estrellas", str(i), 3)
		config.set_value("Desbloqueados", str(i), true)
		config.set_value("Desbloqueados", str(i + 1), true)
	config.save("user://progreso.cfg")
	get_tree().reload_current_scene()
