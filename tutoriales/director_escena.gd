extends AnimationPlayer
var animaciones_activadas:bool

func pausar():
	get_tree().paused = true
func des_pausar():
	get_tree().paused = false

func primera_animacion(jugado):
	animaciones_activadas = not jugado
	if animaciones_activadas:
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

func giro_planta():
	if animaciones_activadas:
		play("GirarPlanta")
