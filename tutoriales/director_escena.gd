extends AnimationPlayer
var animaciones_activadas:bool
@export var nivel: NivelJugable
@export var jardin: Jardin = null
@export var ui: Interfas = null
var objeto_movil:ObjetosMoviles = null
var paso_de_animacion:int = 0
var sector_actual:int
var nivel_actual:int

func pausar():
	get_tree().paused = true
func des_pausar():
	get_tree().paused = false
func activar_mariposa():
	jardin.jardinero.mariposas_movibles = true

func primera_animacion(jugado):
	paso_de_animacion = 1
	evaluar_si_se_jugo_el_tutorial_antes()
	animaciones_activadas = not jugado
	if animaciones_activadas and paso_de_animacion == 1:
		play("Iniciar_tutorial")
func segunda_animacion():
	print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	if animaciones_activadas:
		play("segundo_paso")

func apagar_interfas():
	if animaciones_activadas:
		play("apagar_interfas")
		await animation_finished
		giro_planta()
func fin():
	if animaciones_activadas:
		play("final")
		#Dios.bd_externa["sectores"][nivel.seccion_actual]["niveles"][nivel.nivel_actual]["ya_fue_jugado"] = true

func grabar_termino_de_tutorial():
	Dios.bd_externa["sectores"]["seccion_"+str(nivel.numero_de_sector)]["niveles"]["nivel_"+str(nivel.numero_de_nivel)]["ya_fue_jugado"] = true
#region SECTOR 1
func giro_planta():
	if animaciones_activadas:
		play("GirarPlanta")
#endregion

#region SECTO 3
func mover_objeto():
	if paso_de_animacion == 1:
		paso_de_animacion = 2
		play("cartelObjetos")
func cargar_plantas():
	Dios.bd_externa["sectores"]["seccion_3"]["niveles"]["nivel_1"]["ya_fue_jugado"]
	Dios.bd_externa["sectores"]["seccion_3"]["niveles"]["nivel_2"]["ya_fue_jugado"] = true
	var especie_planta = nivel.Especie_planta.duplicate()
	ui.catalogo_plantas.iniciar_catalogo(especie_planta, jardin)
func evaluar_si_se_jugo_el_tutorial_antes():
	var nivel_1_s_3_fue_ganado = Dios.bd_externa["sectores"]["seccion_3"]["niveles"]["nivel_1"]["ya_fue_jugado"]
	var nivel_2_s_3_fue_ganado = Dios.bd_externa["sectores"]["seccion_3"]["niveles"]["nivel_2"]["ya_fue_jugado"]
	if nivel_1_s_3_fue_ganado or nivel_2_s_3_fue_ganado:
		paso_de_animacion = 0

#endregion
