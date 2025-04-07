shader_type canvas_item;

uniform bool animated = false;
//uniform float red_displacement : hint_range(-1.0,1.0) = .5;
uniform float green_displacement : hint_range(-1.0,1.0) =.7;
//uniform float blue_displacement : hint_range(-1.0,1.0) = .5;
uniform float intensity : hint_range(0.0,100.0) = 100.0;


void fragment()
{
	if (animated) {
		vec4 baseTexture = texture(TEXTURE, UV);
		//vec4 color1 = texture(TEXTURE, UV+vec2(sin(TIME*0.2*intensity), tan(UV.y)));
		vec4 color2 = texture(TEXTURE, UV+vec2(fract(TIME*0.01*intensity), cos(fract(TIME*intensity)*10.0)));
		//vec4 color3 = texture(TEXTURE, UV+vec2(fract(TIME*0.1*intensity), tan(TIME*0.02*intensity)));
		COLOR.r = COLOR.r + green_displacement*texture(TEXTURE, UV-vec2(sin(TIME*0.1*intensity) + 0.2, 0.1)).r;
		COLOR.g = COLOR.g +  green_displacement*texture(TEXTURE, UV+vec2(- 0.2, sin(TIME*0.1*intensity))).g;
		COLOR.b = COLOR.b + green_displacement*texture(TEXTURE, UV+vec2(sin(TIME*0.1*intensity) + 0.2, 0.1)).b;
	}
}