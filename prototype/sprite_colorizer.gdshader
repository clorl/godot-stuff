shader_type canvas_item;

uniform vec3 color_1 : source_color = vec3(1.0);
uniform vec3 color_2 : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (all(lessThan(COLOR.xyz,vec3(0.5)))) {
		COLOR.xyz = vec3(1.0);
		COLOR.xyz *= color_2;
	} else {
		COLOR.xyz = clamp(COLOR.xyz, 0.1, 1.0);
		COLOR.xyz = mix(color_2, color_1, COLOR.xyz);
	}
}
