class_name SoundEffect 
extends Resource
## Sound effect resource, used to configure unique sound effects for use with the AudioManager. Passed to [method AudioManager.create_2d_audio_at_location()] and [method AudioManager.create_audio()] to play sound effects.

## Stores the different types of sounds effects available to be played to distinguish them from another. Each new SoundEffect resource created should add to this enum, to allow them to be easily instantiated via [method AudioManager.create_2d_audio_at_location()] and [method AudioManager.create_audio()].
enum SOUND_EFFECT_TYPE {
	MARIPOSA_FLY, ## tiene que lupear mientras se anima [SI]
	MARIPOSA_PICKUP, ## animacion freezeo [SI]
	MARIPOSA_PLACE, ## apoyar mariposa [SI]
	
	LEVEL_RESTART, ## Esta la base, falta editar | reinicio nivel [SI]
	PLANTA_PICKUP, ## ¿poner mas onda? | agarrar planta, toda circunstancia [SI]
	PLANTA_PLACE, ## Dejar en grilla (y se planta) [SI]
	PLANTA_ROTATE, ## rotar... [SI]
	PLANTA_MISTAKE, ## ??? nadie te conoce 

	LIBRO_CHANGE_PAGE, ## A Seleccionar y Cortar | una pagina de libro []
	LIBRO_SCROLL_PAGES, ## A Seleccionar y Cortar | muchas maginas []
	LIBRO_OPEN_SCENE, ## abrir escena (pa cerrar tambien) [SI]
	LIBRO_COVER, ## Cambio de painga (hacia tapas, osea, cerar abrir) [SI]

	PAPEL_FLY, ## Papelitos de mariposas saliendo [SI]
	PAPEL_INSERT, ## papelitos de mariposa entrando al libro [SI]

	VICTORIA, ## victoria [SI]
	BUTTON_HOVER, ## boton hover [SI]
	BUTTON_PRESS, ##  press [SI]
	UI_CHANGE, ## Barras de menu de opciones (cambiar en el slid) []
	ZOOM, ## transicion de manu nivel a nivel []
	WOOSH, ## De momento sin uso [SI]
	SLIDE, ## De momento sin uso []
	POP_MULTI, ## Cuando salen las estrellitas al ganar []
	POP, ## Ultima estrella (la que se pega arriba) []
	
	OBJETO_PICKUP, ## ¿poner mas onda? | agarrar planta, toda circunstancia [SI]
	OBJETO_PLACE, ## Dejar en grilla (y se planta) [SI]
	OBJETO_ROTATE, ## rotar... [SI]
	OBJETO_MISTAKE, ## ??? nadie te conoce 
}

@export_range(0, 10) var limit: int = 5 ## Maximum number of this SoundEffect to play simultaneously before culled.
@export var type: SOUND_EFFECT_TYPE ## The unique sound effect in the [enum SOUND_EFFECT_TYPE] to associate with this effect. Each SoundEffect resource should have it's own unique [enum SOUND_EFFECT_TYPE] setting.
@export var sound_effect: AudioStream ## The [AudioStreamMP3] audio resource to play.
@export_enum("sfx", "ui","musica") var canal_audio: String = "sfx"
@export_range(-40, 20) var volume: float = 0 ## The volume of the [member sound_effect].
@export_range(0.0, 4.0,.01) var pitch_scale: float = 1.0 ## The pitch scale of the [member sound_effect].
@export_range(0.0, 1.0,.01) var pitch_randomness: float = 0.0 ## The pitch randomness setting of the [member sound_effect].

var audio_count: int = 0 ## The instances of this [AudioStreamMP3] currently playing.

## Takes [param amount] to change the [member audio_count]. 
func change_audio_count(amount: int) -> void:
	audio_count = max(0, audio_count + amount)

## Checkes whether the audio limit is reached. Returns true if the [member audio_count] is less than the [member limit].
func has_open_limit() -> bool:
	return audio_count < limit


## Connected to the [member sound_effect]'s finished signal to decrement the [member audio_count].
func on_audio_finished() -> void:
	change_audio_count(-1)
