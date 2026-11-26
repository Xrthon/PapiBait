shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform float aspect_ratio = 1.777;
uniform vec4 glow_color : source_color = vec4(1.0, 0.82, 0.36, 1.0);
uniform vec4 cover_color : source_color = vec4(0.09, 0.05, 0.02, 1.0);
uniform float ray_count = 14.0;
uniform float ray_speed = 1.5;

void fragment() {
	vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
	vec2 offset = UV - center;
	offset.x *= aspect_ratio;
	float distance_to_center = length(offset);
	float angle = atan(offset.y, offset.x);

	float glow_amount = smoothstep(0.0, 0.45, progress);
	vec3 golden_color = mix(screen_color, screen_color * glow_color.rgb * 1.25 + glow_color.rgb * 0.2, glow_amount);
	float rays = 0.5 + 0.5 * sin(angle * ray_count + TIME * ray_speed);
	golden_color += glow_color.rgb * rays * smoothstep(1.4, 0.0, distance_to_center) * glow_amount * 0.45;

	float iris_radius = mix(2.2, 0.0, smoothstep(0.3, 1.0, progress));
	float ring = smoothstep(0.05, 0.0, abs(distance_to_center - iris_radius)) * step(0.001, iris_radius);
	float outside_iris = smoothstep(iris_radius, iris_radius + 0.015, distance_to_center);

	vec3 final_color = mix(golden_color, cover_color.rgb, outside_iris);
	final_color = mix(final_color, glow_color.rgb * 1.2, ring * 0.9);
	COLOR = vec4(final_color, 1.0);
}
