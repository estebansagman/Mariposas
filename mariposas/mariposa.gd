extends Node2D
class_name Mariposa # pensar una herencia abstracta de "fichas" tanto para plantas como para mariposas

signal eliminando
signal enfocada(mariposa:Mariposa)
signal fuera_de_foco

@export var datos:RecursoMariposa
@onready var textura: Sprite2D = $Textura
var id_mariposa = 0
var estructura:Array[Vector2i] = [Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(1,1)]
var posicion_jardin:Array[Vector2i]
var requisitos_correctos:bool = false
var esta_seleccionada:bool = false
var focus = true

func _ready() -> void:
	poner_textura()

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("aceptar") and focus:
		#seleccionar_mariposa()

func get_nombre()->String: return datos.nombre_Mariposa
func get_requisitos()->Array[Dios.Especie]: return datos.requisitos
func get_estructura()->Array[Vector2i]: return estructura

func set_id_mariposa(valor:int): id_mariposa = valor
func poner_textura(): if datos: textura.texture = datos.textura

func confirmar_requerimientos(casillas:Array[Dios.Especie])->bool: #hay que pasar las casillas masticadas
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

func iluminar():
	var i = 1.5 
	modulate = Color(i, i, i, 1.0)
func apagar():
	var i = 1.0 
	modulate = Color(i, i, i, 1.0)

func seleccionar_mariposa():
	esta_seleccionada = true
	emit_signal("seleccionado",self)
func soltar_mariposa():
	esta_seleccionada = false
	emit_signal("soltando")
func activar_boton():
	emit_signal("eliminando")
