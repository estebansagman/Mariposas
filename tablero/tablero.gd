extends TileMapLayer
class_name Tablero # hay que ver si combiene que este sea "lienzo" y el control, el tablero en si.

@export var source_tile_set:int = 1 # get_tile_set_source()
@export var id_de_textura_base:Vector2i # get_coordenada_textura_base()
@export var id_alternativo_foco:int = 1 # get_coordenada_textura_base()
@export var casilla_normal:String = "tierra"
@export var casilla_bloqueo:String = "bloqueo"
@onready var foco: TileMapLayer = $"../foco"


#var planta:Planta

#region DATOS DICCIONARIO
var focus_key:String = "focus"
var ocupado_key:String ="ocupado"
var tipo_casilla_key:String ="tipo_casilla"
var recurso_key:String ="recurso"
var nombre_key:String ="nombre"
var id_planta_key:String ="id_planta"
var id_mariposa_key:String = "id_mariposa"
var id_set_source_key:String ="id_set_source"
var coord_atlas_key:String ="coord_atlas"
var id_alternativo_key:String ="id_alternativo"
var tipo:String = "tipo"
var mariposa: = "hay_mariposa"
#endregion

var keys_de_diccionario:Array[String] = [focus_key,ocupado_key,tipo_casilla_key,
										recurso_key,nombre_key,tipo,mariposa,
										id_planta_key,id_mariposa_key,id_set_source_key,
										coord_atlas_key,id_alternativo_key]
var celdas: Dictionary = {}

func _ready() -> void:
	_generar_grilla()

#region GETERS
func leer_celda(celda:Vector2i):
	if celda in celdas:
		for key in keys_de_diccionario:
			print(key,": ",celdas[celda][key])	
func get_posicion_fisica(celda:Vector2i)->Vector2: return local_to_map(celda)
func get_planta_en_celda(celda:Vector2i) -> Planta:return celdas[celda][recurso_key]
func get_ocupacion_de_celda(celda:Vector2i) -> bool: return celdas[celda][ocupado_key]
func get_existencia_de_mariposas(celda:Vector2i)->bool: return celdas[celda][mariposa]
func get_tipo(celda:Vector2i) -> Dios.Especie: return celdas[celda][tipo]
func get_id_planta(celda:Vector2i): return celdas[celda][id_planta_key]
#endregion

func corroborar_celda(celda:Vector2i)->bool:
	if celda in celdas:
		return true
	else: return false

func pintar_lienzo(): #se queda
	foco.clear()
	for celda in celdas: 
		pintar_focus(celda)

func pintar_focus(celda:Vector2i ):
	if celdas[celda][focus_key]:
		var id_source = celdas[celda][id_set_source_key]
		var coord_atlas = celdas[celda][coord_atlas_key]
		var ide_alternativo = celdas[celda][id_alternativo_key] 
		foco.set_cell(celda,id_source,coord_atlas,ide_alternativo)

func focusear(celda:Vector2i):
	celdas[celda][focus_key] = true
	
func soltar_foco(celda:Vector2i):
	celdas[celda][focus_key] = false

func _generar_grilla():
	for celda in get_used_cells(): #se trae como parametro el "lienzo"
		var coordenada_atlas:Vector2i = get_cell_atlas_coords(celda) 
		match coordenada_atlas:
			Vector2i(0,0): # Esteban del futuro: "esta es la posicion del atlas"
				_formatear_celda(celda,false,casilla_normal,coordenada_atlas)
			Vector2i(0,1): 
				_formatear_celda(celda,true,casilla_bloqueo,coordenada_atlas)

func _formatear_celda(celda:Vector2i,ocupacion:bool,tipo_casilla:String,coordenada_atlas:Vector2i):
	celdas[celda] = {}
	celdas[celda][focus_key] = false
	celdas[celda][ocupado_key] = ocupacion
	celdas[celda][tipo_casilla_key] = tipo_casilla
	celdas[celda][recurso_key] = null
	celdas[celda][nombre_key] = ""
	celdas[celda][tipo] = -1
	celdas[celda][mariposa] = false
	celdas[celda][id_planta_key] = -1
	celdas[celda][id_mariposa_key] = -1
	celdas[celda][id_set_source_key] = source_tile_set
	celdas[celda][coord_atlas_key] = coordenada_atlas
	celdas[celda][id_alternativo_key] = id_alternativo_foco
	
func ocupar_celda(celda:Vector2i, planta:Planta = null,mariposa:Mariposa = null):
	if planta: #aca es dibde tendria todo el sentido la HERENCIA de objeto "pieza" o algo asi
		celdas[celda][ocupado_key] = true
		celdas[celda][recurso_key] = planta 
		celdas[celda][nombre_key] = planta.get_nombre_planta() 
		celdas[celda][tipo] = planta.get_tipo_planta()
		#celdas[celda][id_mariposa_key] = mariposa.id_mariposa
		celdas[celda][id_planta_key] = planta.get_id_planta()
	if mariposa:
		celdas[celda][mariposa] = true
		celdas[celda][id_mariposa_key] = mariposa.id_mariposa

func sacar_mariposa(celda:Vector2i):
	celdas[celda][mariposa] = false
	celdas[celda][id_mariposa_key] = -1

func vaciar_celda(celda:Vector2i):
	#print("ejecutado vaciar celda")
	celdas[celda][ocupado_key] = false
	celdas[celda][tipo_casilla_key] = casilla_normal
	celdas[celda][recurso_key] = null 
	celdas[celda][nombre_key] = ""
	celdas[celda][tipo] = -1
	#celdas[celda][mariposa] = false
	celdas[celda][id_planta_key] = 0
	celdas[celda][id_set_source_key] = source_tile_set
	celdas[celda][coord_atlas_key] = id_de_textura_base
	celdas[celda][id_alternativo_key] = id_alternativo_foco
