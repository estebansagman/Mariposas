extends Control
signal pasar_nivel

@onready var SELECTOR_NIVELES:String = "res://menus/selector_niveles/selector_niveles.tscn"
@export var puntaje_maximo:float
@export var una_estrella:float = 0
@export var dos_estrellas:float = 0
@export var tres_estrellas:float = 0
@export var se_gana:bool
@export var estrella_apagada:Color = Color(0, 0, 0, 1.0)
@export var estrella_prendida:Color = Color(1, 1, 1, 1.0)
@export var puntaje_actual:int # a borrar, solo experimental

@onready var alerta_seleccion: ColorRect = $AlertaSeleccion
@onready var puntaje: sistema_puntaje = $Puntaje
@onready var cartel_final: Panel = $Cartel_final
@onready var timer: Timer = $Timer
var superado:bool = false


#func _ready() -> void:
	#puntaje.puntaje_maximo = puntaje_maximo
	#puntaje.una_estrella = una_estrella
	#puntaje.dos_estrellas = dos_estrellas
	#puntaje.tres_estrellas = tres_estrellas
	#puntaje.se_gana = se_gana
	#puntaje.estrella_apagada = estrella_apagada
	#puntaje.estrella_prendida = estrella_prendida
	#puntaje.puntaje = puntaje_actual
	#puntaje.generar_stats()

func pasar_datos_puntaje(nivel):
	puntaje.indice = nivel
	puntaje.puntaje_maximo = puntaje_maximo
	puntaje.una_estrella = una_estrella
	puntaje.dos_estrellas = dos_estrellas
	puntaje.tres_estrellas = tres_estrellas
	puntaje.se_gana = se_gana
	puntaje.estrella_apagada = estrella_apagada
	puntaje.estrella_prendida = estrella_prendida
	puntaje.puntaje = puntaje_actual
	puntaje.generar_stats()

func recalcular_puntaje(valor):
	puntaje.puntaje = puntaje.puntaje + valor
	puntaje.calcular_estrellas()

func alerta_de_seleccion():
	alerta_seleccion.show()
func apagar_alerta_de_seleccion():
	alerta_seleccion.hide()

func superar_nivel():
	if !superado:
		cartel_final.show()
	superado = true
	
func quedarme_aca():
	cartel_final.hide()

func volver_al_menu():
	get_tree().change_scene_to_file(SELECTOR_NIVELES)

func pasar_al_siguiente_nivel():
	if superado:
		#get_tree().change_scene_to_file(SELECTOR_NIVELES)
		emit_signal("pasar_nivel")
	else: 
		alerta_de_seleccion()
		timer.start()

func reiniciar_nivel():
	get_tree().reload_current_scene()
