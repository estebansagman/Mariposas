extends TextureRect
#
#@onready var mi_texto = $RichTextLabel
#@onready var size_base = 230
#var texto: String = "Bandera Argentina"
#@export var tamano_letra_base: int = 36
#
#var ancho_base: float = 0.0

#func _ready() -> void:
	#cambiar_texto(texto)
	#item_rect_changed.connect(_escalar_texto_limpio)

#func _escalar_texto_limpio() -> void:
	#var escala_actual = mi_texto.size.x / size_base
	#var nuevo_tamano = int(tamano_letra_base * escala_actual)
	#nuevo_tamano = clamp(nuevo_tamano, 16, tamano_letra_base)
	#mi_texto.add_theme_font_size_override("normal_font_size", nuevo_tamano)

#func cambiar_texto(nuevo_texto: String) -> void:
	#texto = nuevo_texto
	#if mi_texto != null:
		#mi_texto.text = nuevo_texto
