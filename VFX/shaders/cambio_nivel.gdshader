shader_type canvas_item;

uniform sampler2D viewport;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
vec4 tex = texture(viewport,SCREEN_UV);
COLOR = tex;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
