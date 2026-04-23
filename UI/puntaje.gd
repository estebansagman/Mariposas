extends HBoxContainer
class_name sistema_puntaje
signal puntaje_alcansado

#@export var puntaje_maximo:float
#@export var una_estrella:float = 0
#@export var dos_estrellas:float = 0
#@export var tres_estrellas:float = 0
#@export var se_gana:bool
@export var estrella_apagada:Color = Color(0, 0, 0, 1.0)
@export var estrella_prendida:Color = Color(1, 1, 1, 1.0)
@export var puntaje:int

@onready var estrella_1: TextureRect = $Estrella
#@onready var estrella_2: TextureRect = $Estrella2
#@onready var estrella_3: TextureRect = $Estrella3

var indice:int
var lista_estrellas:Array = []

func encendido_estrellas():
	estrella_1.modulate = estrella_prendida

func actualizar_visual(completado: bool):
	if completado:
		estrella_1.modulate = estrella_prendida
	else:
		estrella_1.modulate = estrella_apagada

#func _ready() -> void:
	#generar_stats()

#func generar_stats():
	#print("A VER QUE PASA: ",indice)
	#if una_estrella+dos_estrellas+tres_estrellas == 0:
		#una_estrella = puntaje_maximo*(1/3)
		#dos_estrellas = puntaje_maximo*((1/3)*2)
		#tres_estrellas = puntaje_maximo
	#lista_estrellas = [[una_estrella,estrella_1],
					  #[dos_estrellas,estrella_2],
					  #[tres_estrellas,estrella_3]]
	#if se_gana:
		#calcular_estrellas()

#func calcular_estrellas():
	#if puntaje >= tres_estrellas:
		#encendido_estrellas(3)
		#_ganar(3)
	#elif puntaje >= dos_estrellas:
		#encendido_estrellas(2)
		#_ganar(2)
	#elif puntaje >= una_estrella:
		#encendido_estrellas(1)
		#_ganar(1)
	#else:
		#encendido_estrellas(0)

#func encendido_estrellas():
	#estrella_1.modulate = estrella_prendida
	#for i in range(lista_estrellas.size()):
		#var estrella = lista_estrellas[i]
		#if i < estrellas_ganadas:
			#estrella[1].modulate = estrella_prendida
		#else:
			#estrella[1].modulate = estrella_apagada

#func _ganar(estrellas):
	#if se_gana:
		#emit_signal("puntaje_alcansado")
		#_guardar_datos(estrellas)

#func _guardar_datos(estrellas):
	#print("A VER QUE PASA: ",indice," a: ",estrellas)
	#Dios.guardar_estrellas(indice, estrellas)
