extends Node

#const RUTA_DE_GUARDADO = "user://progreso.json"
#
#var progreso = {
	#"1": {"puntos": 0, "estrellas": 0, "desbloqueado": true}
#}

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

#func _ready():
	#cargar()
#
#func guardar_nivel(num: int, pts: int, est: int):
	#var n = str(num)
	#if not progreso.has(n) or pts > progreso[n].puntos:
		#progreso[n] = {"puntos": pts, "estrellas": est, "desbloqueado": true}
	#var siguiente = str(num + 1)
	#if not progreso.has(siguiente):
		#progreso[siguiente] = {"puntos": 0, "estrellas": 0, "desbloqueado": true}
	#
	#salvar_a_disco()
#
#func salvar_a_disco():
	#var file = FileAccess.open(RUTA_DE_GUARDADO, FileAccess.WRITE)
	#file.store_line(JSON.stringify(progreso))
#
#func cargar():
	#if FileAccess.file_exists(RUTA_DE_GUARDADO):
		#var file = FileAccess.open(RUTA_DE_GUARDADO, FileAccess.READ)
		#var json = JSON.new()
		#json.parse(file.get_as_text())
		#progreso = json.data
#
#func resetear_progreso():
	#progreso = {
		#"1": {"puntos": 0, "estrellas": 0, "desbloqueado": true}
	#}
	#salvar_a_disco()
	#print("Progreso reseteado con éxito")
