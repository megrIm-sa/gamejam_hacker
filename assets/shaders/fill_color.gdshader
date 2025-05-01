shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.5;
uniform vec4 fill_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform bool fill_from_left = true;
uniform float threshold : hint_range(0.0, 1.0) = 0.8;

void fragment() {
	vec2 uv = UV;
	vec4 tex_color = texture(TEXTURE, uv);

	float fill_edge = fill_from_left ? progress : 1.0 - progress;
	bool should_fill = (fill_from_left && uv.x <= fill_edge) ||
	                   (!fill_from_left && uv.x >= fill_edge);

	float brightness = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

	vec4 final_color = tex_color;

	if (should_fill && brightness >= threshold) {
		final_color.rgb = fill_color.rgb;
	}

	COLOR = vec4(final_color.rgb, tex_color.a);
}
