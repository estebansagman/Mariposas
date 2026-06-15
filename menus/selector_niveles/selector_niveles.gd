extends Control
@onready var MENU_INICIO:String = "res://menus/menu_inicio/menu_inicio.tscn"
@onready var nivel_elegido:String = "res://niveles/niveles/Nivel_1.tscn"
var nivel_seleccionado = false
@onready var alerta_bloqueo: ColorRect = $AlertaBloqueo

@onready var lista_sectores: VBoxContainer = $ScrollContainer/Lista_sectores
@onready var timer: Timer = $Timer

var indice:int
var sector_actual: int 

func _ready() -> void:
	await get_tree().process_frame
	actualizar_estado()
	AudioManager.conectar_botones_del_menu(self)
	AudioManager.volver_al_menu()

func actualizar_estado():
	for id_sector in Dios.bd_externa["sectores"].keys():
		var numero_actual = int(id_sector.replace("seccion_", ""))
		if numero_actual == 1:
			Dios.bd_externa["sectores"][id_sector]["desbloqueo"] = true
			continue
		var id_anterior = "seccion_" + str(numero_actual - 1)
		var ganados_anterior = Dios.bd_externa["sectores"][id_anterior]["niveles_superados"]
		var requisito_sector_actual = Dios.bd_interna["sectores"][id_sector]["requisito"]
		if ganados_anterior >= requisito_sector_actual:
			Dios.bd_externa["sectores"][id_sector]["desbloqueo"] = true

	Dios.guardar_bd_externa()
	
	var seccion=1
	for hijo in lista_sectores.get_children():
		if hijo is Sector:
			hijo.numero_de_seccion = seccion
			seccion += 1
			hijo.verificar_condiciones()
		if hijo is contenedor_niveles:
			for item in hijo.get_children():
				item.dar_indice()
				item.nivel_elejido.connect(self.seleccionar_nivel)

func seleccionar_nivel(nivel, indice_b, sector_b,reemplazar):
	nivel_seleccionado = true
	indice = indice_b
	sector_actual = sector_b
	nivel_elegido = nivel
	if not Dios.bd_externa["sectores"]["seccion_"+str(sector_actual)]["desbloqueo"]:
		timer.start()
		alerta_bloqueo.show()
		return
	
	instanciar_nivel(reemplazar)
	
	#if reemplazar:
		#entrar_al_nivel()
	#else:
		#mostrar_nivel()

func instanciar_nivel(reemplazar):
	if !reemplazar:
		nivel = load(nivel_elegido).instantiate()
		get_tree().current_scene.add_child(nivel,true,Node.INTERNAL_MODE_FRONT)
	else:
		var escena_actual = get_tree().current_scene
		self.get_parent().remove_child(self)
		#nivel.get_parent().remove_child(nivel)
		nivel.reparent(escena_actual.get_tree().current_scene.get_parent(),true)
		#get_tree().current_scene.get_child(0).queue_free()
		escena_actual.get_child(0).queue_free()
		#escena_actual.get_tree().paused = false
		#nivel.get_parent().remove_child(nivel)

var nivel:Node

func entrar_al_nivel():
	get_tree().paused = false
	get_tree().change_scene_to_file(nivel_elegido)

func mostrar_nivel():
	var escena = load(nivel_elegido).instantiate()
	#escena.set_process(false)
	get_tree().current_scene.add_child(escena,true,Node.INTERNAL_MODE_FRONT)

func vovler_al_menu():
	get_tree().change_scene_to_file(MENU_INICIO)

func apagar_aletra():
	alerta_bloqueo.hide()
