extends Resource
class_name Recompensa

#el dato de las plantas son las mariposas, sin embargo, el dato en si es
#la mariposa, contrasta su lista con las mariposa desbloqueada y la muestra.

@export_enum(
	"bandera_argentina",
	"cuatro_ojos",
	"espejito",
	"limonero",
	"perezosa",
	"bataraza"
	) var mariposa:String

@export_enum(
	"nombre",
	"nombre_cientifico",
	"textura_libro",
	"textura_oruga_libro",
	"dato curioso 1",
	"dato curioso 2"
) var dato_mariposa:Array[String]
