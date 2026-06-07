extends PanelContainer

var polaroid_pos:Vector2 = Vector2(960,540)
@onready var viewport: SubViewport = %SubViewport
@onready var camara: Camera2D = $Camera2D
var escena_inicial = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_meta("escena_inicial"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
