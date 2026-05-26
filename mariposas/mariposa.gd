extends Node2D
class_name Mariposa # pensar una herencia abstracta de "fichas" tanto para plantas como para mariposas

signal eliminando
signal enfocada(mariposa:Mariposa)
signal fuera_de_foco

@export var key_mariposa:String
@onready var mariposa_3d: MeshInstance3D = %Mariposa3D

var id_mariposa = 0
var estructura:Array[Vector2i] = [Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(1,1)]
var posicion_jardin:Array[Vector2i]
var requisitos_correctos:bool = false
var esta_seleccionada:bool = false
var focus = true
var mariposa_detectada = false
@onready var animation_player: AnimationPlayer = %AnimationPlayer

const HIGHLIGHT_MARIPOSA = preload("uid://bfai2a4hwlee7")


var tween_activo: Tween

func _ready() -> void:
	poner_textura()

func get_nombre()->String: return Dios.bd_interna["mariposas"][key_mariposa]["nombre"]
func get_requisitos()->Array: 
	var lista = Dios.bd_interna["mariposas"][key_mariposa]["plantas_requeridas"]
	return lista
func get_estructura()->Array[Vector2i]: return estructura

func set_id_mariposa(valor:int): id_mariposa = valor

func poner_textura():
	var new_mat = mariposa_3d.get_surface_override_material(0).duplicate()
	var ruta_textura = Dios.bd_interna["mariposas"][key_mariposa]["textura_juego"]
	var textura_cargada = load(ruta_textura)
	
	if Dios.bd_interna["mariposas"].has(key_mariposa):
		new_mat.set("albedo_texture",textura_cargada)
		mariposa_3d.set_surface_override_material(0,new_mat)

func confirmar_requerimientos(casillas:Array[String])->bool: #hay que pasar las casillas masticadas
	requisitos_correctos = true
	for requerimiento in get_requisitos():
		if requerimiento not in casillas:
			requisitos_correctos = false
			break
	return requisitos_correctos

func prender_focus():
	emit_signal("enfocada",self)

func apagar_focus():
	emit_signal("fuera_de_foco")

func iluminar(valido):

	if valido:
		modulate = Color.WHITE  #Color("a9b162") Color("719a5f")
	else:
		modulate = Color("a84047")  #Color("8b2b40")

func apagar():
	#var i = 1.0 
	modulate = Color.WHITE

func seleccionar_mariposa():
	esta_seleccionada = true
	emit_signal("seleccionado",self)
func soltar_mariposa():
	esta_seleccionada = false
	emit_signal("soltando")
func activar_boton():
	emit_signal("eliminando")


func animar_spawn( parcela:Vector2i, pos_global)->void:
	if tween_activo and tween_activo.is_valid():
			tween_activo.kill() 
	if not animation_player.is_playing():
		animation_player.play()
	
	var modelo:Node3D = find_child("Mariposa3D",true)
	var duration:float = 0.5
	var loops:int = 1
	tween_activo = create_tween()

	modelo.global_rotation_degrees = Vector3(randf_range(-30,30),randf_range(-90,90),randf_range(-45,45))
	
	tween_activo.set_ease(Tween.EASE_OUT)
	tween_activo.set_trans(Tween.TRANS_BACK)

	animation_player.play()
	for loop in loops:
		tween_activo.parallel().tween_property(self,"global_position",Vector2(randf_range(250,750),randf_range(100,600)),duration)
		tween_activo.tween_interval(duration)
		tween_activo.tween_property(modelo,"global_rotation_degrees",Vector3(randf_range(-30,30),randf_range(-90,90),randf_range(-45,45)),duration)

	tween_activo.parallel().tween_property(self,"global_position",pos_global,duration)
	tween_activo.tween_interval(duration)
	
	tween_activo.tween_property(modelo,"global_rotation_degrees",Vector3.ZERO,duration)
	await tween_activo.finished
	animation_player.stop()


func display_agarrada()->void:
	animation_player.play_section("Aleteo",0.08,-1,-1,0)

#func agregar_highlight()->void:
	#print("Agregar next pass a ",mariposa_3d.get_surface_override_material(0))
	#mariposa_3d.get_surface_override_material(0).next_pass = HIGHLIGHT_MARIPOSA

func agregar_highlight()->void:
	var t = create_tween()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_ELASTIC)
	#t.tween_property(self,"modulate",Color(8.764, 7.475, 2.318, 1.0),0.5)
	t.tween_property(self,"modulate",Color("ffe082ff"),0.2)
	t.tween_property(self,"modulate",Color.WHITE,0.1)
