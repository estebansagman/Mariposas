extends HBoxContainer
var indice:int
@onready var menu_niveles: Control = $"../../.."


func _ready() -> void:
	indice = get_index()
	for item in get_children():
		item.dar_indice(indice)
		item.nivel_elejido.connect(menu_niveles.seleccionar_nivel)
