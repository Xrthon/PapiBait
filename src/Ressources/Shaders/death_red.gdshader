shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float intensity : hint_range(0.0, 1.0) = 0.0;
uniform vec4 tint_color : source_color = vec4(0.85, 0.05, 0.05, 1.0);
uniform float vignette_strength : hint_range(0.0, 2.0) = 1.2;
uniform float darkness : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
	float luminance = dot(screen_color, vec3(0.299, 0.587, 0.114));
	vec3 tinted_color = mix(screen_color, vec3(luminance) * tint_color.rgb * 1.6, intensity);
	float distance_from_center = distance(UV, vec2(0.5));
	float vignette = smoothstep(0.3, 0.85, distance_from_center) * vignette_strength;
	tinted_color = mix(tinted_color, tint_color.rgb * 0.35, clamp(vignette * intensity, 0.0, 1.0));
	tinted_color = mix(tinted_color, vec3(0.0), darkness);
	COLOR = vec4(tinted_color, 1.0);
}
