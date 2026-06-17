extends VBoxContainer

const VOLUMEN_MAXIMO_GENERAL:int = 0
const VOLUMEN_MAXIMO_MUSICA:int = -10
const VOLUMEN_MAXIMO_AMBIENTE:int = -12
const VOLUMEN_MAXIMO_SFX:int = -4

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
