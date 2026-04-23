extends Node2D
@export var numero_de_nivel:int
@export var numero_de_sector: int
@export var jardin:Jardin
@export var mariposas:Array[RecursoMariposa]
@export var plantas:Array[RecursoPlanta]
@onready var ui: Interfas = $UI
#@onready var catalogo_plantas_2: CatalogoPlantas = $CatalogoPlantas2
@onready var pasar_de_nivel: Timer = $PasarDeNivel

var estrellas:int
var puntos_maximos:int

func _ready() -> void:
	#ui.pasar_datos_puntaje(numero_de_nivel)
	#pasar catalogos a UI
	jardin.naturaleza.generar_mariposas(mariposas)
	ui.catalogo_plantas.iniciar_catalogo(plantas,jardin)
	ui.catalogo_mariposas.iniciar_catalogo(mariposas)
	

func ir_al_siguiente():
	var numero_actual = name.to_int() 
	var siguiente_ruta = "res://niveles/niveles/Nivel_" + str(numero_de_nivel + 1) + ".tscn"
	if ResourceLoader.exists(siguiente_ruta):
		get_tree().change_scene_to_file(siguiente_ruta)
	else:
		print("¡No hay más niveles!")

func sumar_puntos(valor):
	var mariposas_jugadas:Array[Mariposa] = jardin.naturaleza.mariposas_en_juego.duplicate()
	ui.catalogo_mariposas.marcar_mariposas(mariposas_jugadas)
	if mariposas.size() == mariposas_jugadas.size():
		ui.superar_nivel()
		pasar_de_nivel.start()
		Dios.completar_nivel(numero_de_sector, numero_de_nivel)
		print("Nivel guardado: Sector ", numero_de_sector, " Nivel ", numero_de_nivel)
		
func volver_al_Menu():
	get_tree().change_scene_to_file(ui.SELECTOR_NIVELES)
