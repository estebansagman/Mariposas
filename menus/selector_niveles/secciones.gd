extends TextureRect
class_name Sector
const CANDADO_ABIERTO = preload("uid://cl6i2e6w3ekcn")


@export var numero_de_seccion:int
@export var niveles_nescesarios:int

@onready var candado: TextureRect = $Candado
var desbloqueado:bool
@onready var condiciones: Label = $Condiciones

func _ready() -> void:
	condiciones.text = "0 / "+str(niveles_nescesarios) #el primer 0 se reemplaza por cantidad de niveles por seccion
	verificar_condiciones()

func verificar_condiciones():
	var sector_anterior = numero_de_seccion - 1
	var ganados = 0
	
	if numero_de_seccion > 0:
		ganados = Dios.contar_niveles_completados_en_sector(sector_anterior)
	
	condiciones.text = str(ganados) + " / " + str(niveles_nescesarios)
	
	if ganados >= niveles_nescesarios or numero_de_seccion == 0:
		desbloqueado = true
		candado.texture = CANDADO_ABIERTO
		modulate = Color(1, 1, 1, 1) # Para que se vea normal
	else:
		desbloqueado = false
		modulate = Color(0.5, 0.5, 0.5, 1) # Grisado si está bloqueado
	
