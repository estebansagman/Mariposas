extends HBoxContainer

#var indice:int
#@export var indice:int
@onready var menu_niveles: Control = $"../../.."


func _ready() -> void:
	#indice = get_index()
	#print(indice)
	for item in get_children():
		item.dar_indice()
		item.nivel_elejido.connect(menu_niveles.seleccionar_nivel)
	
