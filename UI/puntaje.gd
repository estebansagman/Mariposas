extends HBoxContainer
class_name sistema_puntaje

@export var estrella_apagada:Color = Color(0, 0, 0, 1.0)
@export var estrella_prendida:Color = Color(1, 1, 1, 1.0)
@onready var estrella_1: TextureRect = $Estrella

func actualizar_visual(completado: bool):
	if completado:
		estrella_1.modulate = estrella_prendida
	else:
		estrella_1.modulate = estrella_apagada
