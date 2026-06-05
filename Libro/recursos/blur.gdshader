shader_type canvas_item;

uniform float lod : hint_range(0.0, 5.0) = 0.0; 

void fragment() {
    // Esto va a agarrar la "FOTO FINAL" que escupe el Viewport y la va a blurrear completa
    COLOR = textureLod(TEXTURE, UV, lod);
}
