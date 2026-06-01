extends HBoxContainer

#func _ready() -> void:
	#acomodar_tamaños()

func acomodar_tamaños():
	var hijos: Array = get_children()
	var cantidad_hijos = hijos.size()
	
	var escala_nueva = 1.0

	if cantidad_hijos > 2:
		escala_nueva = 2.0 / cantidad_hijos

	for hijo in hijos:
		if hijo is Control:
			hijo.scale = Vector2(escala_nueva, escala_nueva) 
