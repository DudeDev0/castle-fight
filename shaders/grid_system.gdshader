shader_type spatial;

uniform sampler2D grid_text: repeat_enable, filter_nearest;
uniform vec2 mouse_pos;
uniform vec4 color = vec4(1.0);

void fragment() {
	vec4 text = texture(grid_text, UV * 10.0);
	
	float dist = 0.3 - distance(mouse_pos, SCREEN_UV);
	dist *= 2.0;
	dist = clamp(dist, 0.0, 1.0);
	
	ALBEDO = color.rgb;
	ALPHA = text.a * dist;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
