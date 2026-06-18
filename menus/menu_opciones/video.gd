extends VBoxContainer
@onready var pantalla_completa: TextureButton = $HBoxContainer/PanelControl/ModoPantalla/PantallaCompleta
@onready var ventana: TextureButton = $HBoxContainer/PanelControl/ModoPantalla/Ventana
@onready var ventana_sin_bordes: TextureButton = $HBoxContainer/PanelControl/ModoPantalla/ventanaSinBordes

func establecer_pantalla_ventana() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	pantalla_completa.texture_normal = load("res://menus/menu_opciones/imagenes/cuadrados importantes normal.png")
	ventana.texture_normal = load("res://menus/menu_opciones/imagenes/cuadrados importantes cuadra seleccionado.png")
	ventana_sin_bordes.texture_normal = load("res://menus/menu_opciones/imagenes/cuadrados importantes normal.png")

func establecer_pantalla_completa() -> void:
	pantalla_completa.texture_normal = load("res://menus/menu_opciones/imagenes/cuadrados importantes cuadra seleccionado.png")
	ventana.texture_normal = load("res://menus/menu_opciones/imagenes/cuadrados importantes normal.png")
	ventana_sin_bordes.texture_normal = load("res://menus/menu_opciones/imagenes/cuadrados importantes normal.png")
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

func establecer_pantalla_ventana_sin_bordes() -> void:
	pantalla_completa.texture_normal = load("res://menus/menu_opciones/imagenes/cuadrados importantes normal.png")
	ventana.texture_normal = load("res://menus/menu_opciones/imagenes/cuadrados importantes normal.png")
	ventana_sin_bordes.texture_normal = load("res://menus/menu_opciones/imagenes/cuadrados importantes cuadra seleccionado.png")
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
