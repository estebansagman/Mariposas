extends Control
class_name Pagina
signal seleccion_de_pagina(tipo_hoja,especimen)

@onready var cara_izquierda: Cara = $CaraIzquierda
@onready var cara_derecha: Cara = $CaraDerecha

func mostrar_cara(lado,tipo_de_pagina,especimen="nada"):
	if lado == "izquierda":
		cara_izquierda.show()
		cara_derecha.hide()
		mostrar_tipo_de_pagina(tipo_de_pagina,cara_izquierda,especimen)
	elif lado == "derecha":
		cara_izquierda.hide()
		cara_derecha.show()
		mostrar_tipo_de_pagina(tipo_de_pagina,cara_derecha,especimen)

func mostrar_tipo_de_pagina(tipo_de_pagina,cara:Cara,especimen="nada"):
	match tipo_de_pagina:
		"indice":
			cara.mostrar_indice()
		"mariposa":
			cara.mostrar_mariposa(especimen)
		"planta":
			cara.mostrar_planta(especimen)

func enviar_datos_de_botones(tipo_hoja,especimen):
	emit_signal("seleccion_de_pagina",tipo_hoja,especimen)
