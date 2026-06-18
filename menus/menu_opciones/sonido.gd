extends VBoxContainer

const VOLUMEN_MAXIMO_GENERAL:int = 0
const VOLUMEN_MAXIMO_MUSICA:int = -10
const VOLUMEN_MAXIMO_AMBIENTE:int = -12
const VOLUMEN_MAXIMO_SFX:int = -4

@onready var slider_general: HSlider = $Panel/Controladores/General/sliderGeneral
@onready var slider_musica: HSlider = $Panel/Controladores/Musica/SliderMusica
@onready var slider_ambiente: HSlider = $Panel/Controladores/Ambiente/SliderAmbiente
@onready var slider_sfx: HSlider = $Panel/Controladores/Sfx/SliderSfx


func ajustar_volumen_al_maximo():
	var volumen_general = Dios.bd_externa["opciones"]["sonido"]["general"]
	var volumen_musica = Dios.bd_externa["opciones"]["sonido"]["musica"]
	var volumen_ambiente = Dios.bd_externa["opciones"]["sonido"]["ambiente"]
	var volumen_sfx = Dios.bd_externa["opciones"]["sonido"]["sfx"]
	
	modificar_volumen_general(volumen_general)
	slider_general.value = volumen_general
	
	modificar_volumen_musica(volumen_musica)
	slider_musica.value = volumen_musica
	
	modificar_volumen_ambiente(volumen_ambiente)
	slider_ambiente.value = volumen_ambiente
	
	modificar_volumen_sfx(volumen_sfx)
	slider_sfx.value = volumen_sfx

func aplicar_volumen(nombre_bus: String, volumen_slider: float, vol_maximo: float):
	var bus_index = AudioServer.get_bus_index(nombre_bus)
	var volumen_lineal = volumen_slider / 100.0
	var db = linear_to_db(volumen_lineal) + vol_maximo
	if volumen_slider == 0:
		db = -80
	AudioServer.set_bus_volume_db(bus_index, db)

func modificar_volumen_general(volumen:float):
	aplicar_volumen("Master", volumen, VOLUMEN_MAXIMO_GENERAL)
	Dios.bd_externa["opciones"]["sonido"]["general"] = volumen
	Dios.guardar_bd_externa()

func modificar_volumen_musica(volumen:float):
	aplicar_volumen("musica", volumen, VOLUMEN_MAXIMO_MUSICA)
	Dios.bd_externa["opciones"]["sonido"]["musica"] = volumen
	Dios.guardar_bd_externa()

func modificar_volumen_ambiente(volumen:float):
	aplicar_volumen("ambiente", volumen, VOLUMEN_MAXIMO_AMBIENTE)
	Dios.bd_externa["opciones"]["sonido"]["ambiente"] = volumen
	Dios.guardar_bd_externa()

func modificar_volumen_sfx(volumen:float):
	aplicar_volumen("sfx", volumen, VOLUMEN_MAXIMO_SFX)
	Dios.bd_externa["opciones"]["sonido"]["sfx"] = volumen
	Dios.guardar_bd_externa()
