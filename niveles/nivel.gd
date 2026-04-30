extends Node2D
class_name NivelJugable

@export var numero_de_nivel:int
@export var numero_de_sector: int
@export var jardin:Jardin


var sector = "seccion_"+str(numero_de_sector)
var nivel = "nivel_"+str(numero_de_nivel)

@export_enum(
	"bandera_argentina",
	"cuatro_ojos",
	"espejito",
	"limonero",
	"perezosa",
	"bataraza"
	) var Especie_mariposa:Array[String]
@export_enum(
	"ceibo:A",
	"ceibo:B",
	"coronillo:A",
	"coronillo:B",
	"chilca:A",
	"chilca:B",
	"ruda:A",
	"ruda:B",
	"canario_rojo:A",
	"canario_rojo:B",
	"salvia:A",
	"salvia:B",
	"ruelia:A",
	"ruelia:B",
	"mbrucuya:A",
	"mbrucuya:B",
	"lantana:A",
	"lantana:B"
	) var Especie_planta:Array[String]	
@export var datos_de_libro:Array[Recompensa]

@onready var ui: Interfas = $UI
@onready var pasar_de_nivel: Timer = $PasarDeNivel

var estrellas:int
var puntos_maximos:int

func _ready() -> void:
	jardin.naturaleza.generar_mariposas(Especie_mariposa)
	ui.catalogo_plantas.iniciar_catalogo(Especie_planta,jardin)
	ui.catalogo_mariposas.iniciar_catalogo(Especie_mariposa)
	sistema_debug()

func sumar_puntos():
	var mariposas_jugadas:Array[Mariposa] = jardin.naturaleza.mariposas_en_juego.duplicate()
	ui.catalogo_mariposas.marcar_mariposas(mariposas_jugadas)
	if Especie_mariposa.size() == mariposas_jugadas.size():
		var s_id = "seccion_" + str(numero_de_sector)
		var nivel_id = "nivel_" + str(numero_de_nivel)
		var estado_nivel = Dios.bd_externa["sectores"][s_id]["niveles"][nivel_id]["superado"]
		ui.superar_nivel()
		if !estado_nivel:
			completar_nivel()
			revelar_datos()
		pasar_de_nivel.start()

func completar_nivel():
	var sector_id = "seccion_" + str(numero_de_sector)
	var nivel_id = "nivel_" + str(numero_de_nivel)
	Dios.bd_externa["sectores"][sector_id]["niveles"][nivel_id]["superado"] = true
	Dios.bd_externa["sectores"][sector_id]["niveles_superados"] += 1
	Dios.guardar_bd_externa()

func revelar_datos():
	var sector_id = "seccion_" + str(numero_de_sector)
	var nivel_id = "nivel_" + str(numero_de_nivel)
	if datos_de_libro:
		for recompensa in datos_de_libro:
			var mariposa_id = recompensa.mariposa
			if not Dios.bd_externa["progreso_mariposas"].has(mariposa_id):
				Dios.bd_externa["progreso_mariposas"][mariposa_id] = []
			for dato in recompensa.dato_mariposa:
				if dato not in Dios.bd_externa["progreso_mariposas"][mariposa_id]:
					var clave = Dios.bd_interna["mariposas"][mariposa_id][dato]
					Dios.bd_externa["progreso_mariposas"][mariposa_id].append(clave)
	Dios.guardar_bd_externa()

func guardar_estado_de_tablero(tablero):
	Dios.bd_externa["sectores"][sector][nivel]["momento_de_juego"] = tablero
	Dios.guardar_bd_externa()
	
func volver_al_Menu():
	get_tree().change_scene_to_file(ui.SELECTOR_NIVELES)

func sistema_debug(): #despues borrar
	ui.botones_debug.nivel_jugandose = self
