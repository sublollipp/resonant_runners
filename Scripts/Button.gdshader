shader_type canvas_item;

uniform vec4 target_color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texColor = texture(TEXTURE, UV);
	if (texColor == vec4(1.0, 1.0, 1.0, 1.0)) {
		COLOR = target_color;
	} else {
		COLOR = texColor;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
