shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_opaque;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;
uniform int radius : hint_range(1, 8) = 3;

vec4 quadrant(sampler2D tex, vec2 uv, vec2 offset, int rad) {
	vec3 mean = vec3(0.0);
	vec3 variance = vec3(0.0);
	int count = 0;
	
	// Calcola pixel_size dal viewport
	vec2 texture_size = vec2(textureSize(tex, 0));
	vec2 pixel_size = 1.0 / texture_size;
	
	for (int x = 0; x <= rad; x++) {
		for (int y = 0; y <= rad; y++) {
			vec2 coord = uv + (offset * float(rad) + vec2(float(x), float(y))) * pixel_size;
			vec3 color = texture(tex, coord).rgb;
			mean += color;
			variance += color * color;
			count++;
		}
	}
	
	mean /= float(count);
	variance = abs(variance / float(count) - mean * mean);
	float std_dev = length(variance);
	
	return vec4(mean, std_dev);
}

void fragment() {
	// Calcola i 4 quadranti
	vec4 q1 = quadrant(screen_texture, SCREEN_UV, vec2(-1.0, -1.0), radius);
	vec4 q2 = quadrant(screen_texture, SCREEN_UV, vec2( 1.0, -1.0), radius);
	vec4 q3 = quadrant(screen_texture, SCREEN_UV, vec2(-1.0,  1.0), radius);
	vec4 q4 = quadrant(screen_texture, SCREEN_UV, vec2( 1.0,  1.0), radius);
	
	// Trova il quadrante con deviazione standard minima
	vec3 color = q1.rgb;
	float min_std = q1.a;
	
	if (q2.a < min_std) { color = q2.rgb; min_std = q2.a; }
	if (q3.a < min_std) { color = q3.rgb; min_std = q3.a; }
	if (q4.a < min_std) { color = q4.rgb; min_std = q4.a; }
	
	ALBEDO = color;
	ALPHA = 1.0;
}