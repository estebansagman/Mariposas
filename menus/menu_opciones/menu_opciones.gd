extends Control

@onready var general: VBoxContainer = $Control/NinePatchRect/MarginContainer/General
@onready var video: VBoxContainer = $Control/NinePatchRect/MarginContainer/Video
@onready var sonido: VBoxContainer = $Control/NinePatchRect/MarginContainer/Sonido

@onready var general_boton: TextureButton = $Control/VBoxContainer/general
@onready var sonido_boton: TextureButton = $Control/VBoxContainer/sonido
@onready var video_boton: TextureButton = $Control/VBoxContainer/video



func abrir_menu_de_opciones():
	show()
	oscurecer_iconos()
	entrar_a_general()

func cerrar_menu_de_opciones():
	hide()

func entrar_a_general():
	oscurecer_iconos()
	general_boton.modulate = Color.WHITE
	general.show()
	video.hide()
	sonido.hide()
	
func entrar_a_video():
	oscurecer_iconos()
	video_boton.modulate = Color.WHITE
	general.hide()
	video.show()
	sonido.hide()

func entrar_a_sonido():
	oscurecer_iconos()
	sonido_boton.modulate = Color.WHITE
	general.hide()
	video.hide()
	sonido.show()

func oscurecer_iconos():
	var color_oscuro:Color = Color(0.658, 0.658, 0.658, 1.0)
	general_boton.modulate = color_oscuro
	sonido_boton.modulate = color_oscuro
	video_boton.modulate = color_oscuro
