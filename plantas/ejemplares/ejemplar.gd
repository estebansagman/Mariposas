extends Node2D

#@export var nombre:String
var id_logico: int
var n_giro: int

func configurar(id: int, giro: int):
	id_logico = id
	n_giro = giro
	
	# Aplicamos la rotación visual basada en el giro (0, 90, 180, 270)
	rotation = giro * (PI / 2) 
