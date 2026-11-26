shader_type canvas_item;

uniform vec4 spice_color : source_color = vec4(1.0, 0.46, 0.09, 1.0);
uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.45, 1.0);
uniform float density : hint_range(0.0, 1.0) = 0.55;
uniform float noise_scale = 3.0;
uniform vec2 drift_speed = vec2(0.03, -0.008);
uniform float swirl_strength : hint_range(0.0, 1.0) = 0.35;
uniform float ground_height : hint_range(0.0, 1.0) = 0.65;
uniform float mote_density : hint_range(0.0, 1.0) = 0.5;
uniform float mote_size = 90.0;

float hash(vec2 point) {
	return fract(sin(dot(point, vec2(127.1, 311.7))) * 43758.5453);
}

float value_noise(vec2 point) {
	vec2 cell = floor(point);
	vec2 local = fract(point);
	vec2 smooth_local = local * local * (3.0 - 2.0 * local);
	float bottom = mix(hash(cell), hash(cell + vec2(1.0, 0.0)), smooth_local.x);
	float upper = mix(hash(cell + vec2(0.0, 1.0)), hash(cell + vec2(1.0, 1.0)), smooth_local.x);
	return mix(bottom, upper, smooth_local.y);
}

float fbm(vec2 point) {
	float total = 0.0;
	float amplitude = 0.5;
	for (int octave = 0; octave < 5; octave++) {
		total += value_noise(point) * amplitude;
		point = point * 2.03 + vec2(1.7, 9.2);
		amplitude *= 0.5;
	}
	return total;
}

void fragment() {
	vec2 point = UV * noise_scale;
	vec2 swirl = vec2(fbm(point + TIME * drift_speed * 2.0), fbm(point + vec2(5.2, 1.3) - TIME * drift_speed)) - 0.5;
	float cloud = fbm(point + swirl * swirl_strength * 4.0 + TIME * drift_speed * 10.0);
	float height_fade = smoothstep(ground_height - 0.65, 1.0, UV.y);
	float mist = smoothstep(0.35, 0.85, cloud) * mix(0.35, 1.0, height_fade) * density;

	vec2 mote_cell = floor(UV * mote_size + vec2(TIME * 0.6, TIME * -0.25));
	float mote_seed = hash(mote_cell);
	float twinkle = 0.5 + 0.5 * sin(TIME * (2.0 + mote_seed * 4.0) + mote_seed * 40.0);
	vec2 mote_center = fract(UV * mote_size + vec2(TIME * 0.6, TIME * -0.25)) - 0.5;
	float motes = step(1.0 - mote_density * 0.08, mote_seed) * smoothstep(0.25, 0.0, length(mote_center)) * twinkle;

	vec3 color = mix(spice_color.rgb, glow_color.rgb, smoothstep(0.55, 0.95, cloud));
	color = mix(color, glow_color.rgb, motes);
	COLOR = vec4(color, clamp(mist + motes * 0.8, 0.0, 1.0));
}
