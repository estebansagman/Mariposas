extends Node3D
class_name Hoja
signal izquierda_cambia
signal derecha_cambia
signal animacion_finaliza

@onready var animation_player: AnimationPlayer = $"Page Flip Shapekeys/AnimationPlayer"
const PAGINADELLIBRO = preload("uid://bdrlb6hrsu17b")
@onready var sub_viewport_pagina_1: SubViewport = $SubViewportPagina1
@onready var sub_viewport_pagina_2: SubViewport = $SubViewportPagina2

@onready var lado_a: Pagina = $SubViewportPagina2/LadoA
@onready var lado_b: Pagina = $SubViewportPagina1/LadoB
var es_clon_rafaga: bool = false

func cambiar_imagenes(numero_pagina, paginas, hacia_adelante: bool = true):
	
	var pagina_actual
	var pagina_siguiente
	
	if hacia_adelante:
		pagina_actual = paginas[numero_pagina]
		pagina_siguiente = paginas[numero_pagina - 1]
	else:
		pagina_actual = paginas[numero_pagina + 1]
		pagina_siguiente = paginas[numero_pagina]

	lado_a.mostrar_cara("derecha", pagina_siguiente[0], pagina_siguiente[1])
	lado_b.mostrar_cara("izquierda", pagina_actual[0], pagina_actual[1])
	sub_viewport_pagina_1.render_target_update_mode = SubViewport.UPDATE_ONCE
	sub_viewport_pagina_2.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame

	

func pasar_pagina():
	prender_hoja()
	animation_player.play("Acciones/Avanzar")
	await animation_player.animation_finished
	if not es_clon_rafaga: 
		emit_signal("animacion_finaliza")
		print("hubo cambio FINAL!!!")
	apagar_hoja()

func volver_a_la_pagina_anterior():
	prender_hoja()
	animation_player.play("Acciones/Retroceder")
	await  animation_player.animation_finished
	if not es_clon_rafaga: 
		emit_signal("animacion_finaliza")
		print("hubo cambio FINAL!!!")
	apagar_hoja()

func pasar_rapido(orientacion:String = "derecha"):
	animation_player.speed_scale = 2.0
	if orientacion == "derecha":
		animation_player.play("Acciones/Avanzar")
	elif orientacion == "izquierda":
		animation_player.play("Acciones/Retroceder")
		
	await animation_player.animation_finished
	if not es_clon_rafaga: 
		emit_signal("animacion_finaliza")
		print("hubo cambio FINAL!!!")
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

func cambiar_pagina_izquierda():
	if not es_clon_rafaga:
		emit_signal("izquierda_cambia")
		print("hubo cambio IZQUIERDO!!!")

func cambiar_pagina_derecha():
	if not es_clon_rafaga:
		emit_signal("derecha_cambia")
		print("hubo cambio DERECHO!!!")
