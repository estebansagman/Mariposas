extends Resource
class_name TipoPlanta

@export_enum(
	"ceibo",
	"coronillo",
	"chilca",
	"ruda",
	"canario_rojo",
	"salvia",
	"ruelia",
	"mbrucuya",
	"lantana"
	) var Especie_planta:String
@export_enum("A", "B", "C", "D") var forma: String
