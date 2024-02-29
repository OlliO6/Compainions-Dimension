shader_type canvas_item;

uniform vec3 start_color: source_color;
uniform vec3 end_color: source_color;
uniform float border_size;
uniform float alpha = 1;

uniform sampler2D noise_1 : repeat_enable;
uniform float noise_speed;
uniform float fps;

void fragment() {
	float time = trunc(TIME * fps) / fps;
	vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;
	float noise_value = clamp(texture(noise_1, SCREEN_UV + time * noise_speed).r + texture(noise_1, SCREEN_UV - time * noise_speed).r, 0., 1.);
	vec4 color;
	color.rgb = mix(start_color, end_color, UV.x);
	color.a = alpha * noise_value;
	float x_border = 0.2;
	color.a = min(min(color.a, pow(min(smoothstep(1, 1. - x_border, UV.x ), smoothstep(0, x_border, UV.x)), 2)), pow(min(smoothstep(1, 1. - border_size, UV.y), smoothstep(0, border_size, UV.y)), 2));
	COLOR = color;
}
