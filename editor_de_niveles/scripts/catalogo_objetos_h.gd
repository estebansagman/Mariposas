extends Control
class_name CatalogoObjetosH

const BOTON_OBJETO = preload("uid://r87kwfhadu8p")

#var objetos:Array[String]
var jardin: Jardin
var llaves_objetos:Array[String]

func iniciar_catalogo(key_objeto:Array[String],dato_jardin:Jardin):
	llaves_objetos = key_objeto.duplicate()
	jardin = dato_jardin
	_crear_catalogo()
	await get_tree().process_frame

func _crear_catalogo():
	for llave in llaves_objetos:
		#var recorte = key_planta_completo.split(":")
		#var key_planta = recorte[0]
		#var key_estructura = recorte[1]
		
		var nuevo_boton_objeto: BotonObjeto = BOTON_OBJETO.instantiate()

		nuevo_boton_objeto.key_objeto = llave
		nuevo_boton_objeto.pedido_de_objeto.connect(jardin.origen_plantas.crear_objeto)
		add_child(nuevo_boton_objeto)
