extends Button

@export var boton:TextureButton
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var lista_sectores: VBoxContainer = $"../SubViewport/MenuNiveles/ScrollContainer/Lista_sectores"
@onready var h_box_container_3: contenedor_niveles = $"../SubViewport/MenuNiveles/ScrollContainer/Lista_sectores/HBoxContainer3"

#func _input(event: InputEvent) -> void:
	#print("mouse=", get_viewport().get_mouse_position())
	#print("offset=", sprite_2d.material.get_shader_parameter("mask_offset"))
func _ready() -> void:
	loopear()

func loopear():
	#print(lista_sectores)
	for child in h_box_container_3.get_children():
		print(child)
		cambiar(child)
		await get_tree().create_timer(1.2)

func _on_pressed() -> void:
	loopear()

func cambiar(nodo):
	var target_screen_position = nodo.get_screen_position()
	printerr(target_screen_position)
	#var offset = screen_to_mask_offset(target_screen_position)
	sprite_2d.material.set_shader_parameter(
	"mask_offset",
	screen_to_mask_offset(target_screen_position)
)
	printerr(screen_to_mask_offset(target_screen_position))
	print(screen_to_mask_offset(Vector2(1003.748, 497.6682)))

func screen_to_mask_offset(screen_pos: Vector2) -> Vector2:
	var viewport_size = get_viewport().get_visible_rect().size
	var max_offset = Vector2(3.465, 1.95)

	var normalized = screen_pos / viewport_size

	return (Vector2(0.5, 0.5) - normalized) * max_offset * 2.0

#func screen_to_mask_offset(screen_pos: Vector2) -> Vector2:
	#var viewport_size = get_viewport().get_visible_rect().size
	#var center = viewport_size * 0.5
#
	#var delta = screen_pos - center
#
	#return Vector2(
		#-delta.x * 0.01515,
		 #delta.y * 0.00867
	#)

#func screen_to_mask_offset(screen_pos: Vector2) -> Vector2:
	#var viewport_size = Vector2(1920, 1080)
	#var max_offset = Vector2(3.47, 1.95)
#
	#var uv = screen_pos / viewport_size
#
	#return (Vector2(0.5, 0.5) - uv) * max_offset * 2.0
