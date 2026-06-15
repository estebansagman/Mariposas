extends TextureButton

func _ready() -> void:
	%NotificacionLibro.visible = Dios.mostrar_notif

func update_notif(mostrar) -> void:
	%NotificacionLibro.visible = mostrar
	Dios.mostrar_notif = mostrar
