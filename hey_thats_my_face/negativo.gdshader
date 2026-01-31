shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 col = texture(screen_texture, SCREEN_UV);
    vec3 neg = vec3(1.0) - col.rgb;
    col.rgb = mix(col.rgb, neg, intensity);
    COLOR = col;
}
