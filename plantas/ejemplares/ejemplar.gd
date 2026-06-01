extends Node2D
class_name EjemplarPlanta
#@export var nombre:String
var coordenada_en_tablero:Vector2i
var id_logico: int
var n_giro: int


func configurar(id: int, giro: int):
	id_logico = id
	n_giro = giro
	
	rotation = giro * (PI / 2) 
	
