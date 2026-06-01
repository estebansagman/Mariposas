extends Node3D
class_name Hoja

@onready var animation_player: AnimationPlayer = $"Page Flip Shapekeys/AnimationPlayer"
const PAGINADELLIBRO = preload("uid://bdrlb6hrsu17b")

#func _unhandled_input(event: InputEvent) -> void:
	#pasar_pagina()
	#volver_a_la_pagina_anterior()

func pasar_pagina():
	prender_hoja()
	animation_player.play("Acciones/Avanzar")
	await animation_player.animation_finished
	apagar_hoja()

func volver_a_la_pagina_anterior():
	prender_hoja()
	animation_player.play("Acciones/Retroceder")
	await  animation_player.animation_finished
	apagar_hoja()

func pasar_rapido(orientacion:String = "derecha"):
	animation_player.speed_scale = 4.0
	
	if orientacion == "derecha":
		animation_player.play("Acciones/Avanzar")
	elif orientacion == "izquierda":
		animation_player.play("Acciones/Retroceder")
		
	await animation_player.animation_finished
	queue_free()

func apagar_hoja():
	var librito = get_parent()
	if librito and librito.has_node("SubViewport"):
		librito.get_node("SubViewport").update_mode = SubViewport.UPDATE_DISABLED
	hide()

func prender_hoja():
	var librito = get_parent()
	if librito and librito.has_node("SubViewport"):
		librito.get_node("SubViewport").update_mode = SubViewport.UPDATE_ALWAYS
	show()
