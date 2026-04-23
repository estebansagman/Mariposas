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

var nombre_especies: Array[String] = [
	"CEIBO",
	"CORONILLO",
	"CHILCA",
	"RUDA",
	"CANARIO ROJO",
	"SALVIA",
	"RUELLIA",
	"MBRUCUYA",
	"LANTANA"]


func _ready():
	load_data()

func load_data():
	var error = config.load(SAVE_PATH)
	if error != OK:
		print("Iniciando nueva partida.")

func completar_nivel(id_sector: int, id_nivel: int):
	var clave = str(id_sector) + "_" + str(id_nivel)
	config.set_value("Completados", clave, true)
	config.save(SAVE_PATH)

func esta_desbloqueado(id_sector: int, id_nivel: int) -> bool:
	if id_sector == 1: 
		return true
	var sector_previo = id_sector - 1
	var niveles_ganados = contar_niveles_completados_en_sector(sector_previo)
	return niveles_ganados >= 2 

func contar_niveles_completados_en_sector(id_sector: int) -> int:
	var cuenta = 0
	for i in range(1, 5): 
		var clave = str(id_sector) + "_" + str(i)
		if config.get_value("Completados", clave, false):
			cuenta += 1
	return cuenta


func borrar_todo():
	var dir = DirAccess.open("user://")
	if dir.file_exists("progreso.cfg"):
		dir.remove("progreso.cfg")
	config = ConfigFile.new()
	config.save(SAVE_PATH)
	get_tree().reload_current_scene()

func debug_completar_juego():
	for s in range(0, 3):
		for n in range(1, 5):
			var clave = str(s) + "_" + str(n)
			config.set_value("Completados", clave, true)
	config.save(SAVE_PATH)
	get_tree().reload_current_scene()
