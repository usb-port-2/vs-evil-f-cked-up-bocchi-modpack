//SHADER FROM BASE FNF, ADAPTED BY NEX AND NE_EO
#pragma header

uniform float hue;
uniform float saturation;
uniform float brightness;
uniform float contrast;

vec3 applyHue(vec3 aColor, float aHue)
{
	float angle = radians(aHue);
	vec3 k = vec3(0.57735, 0.57735, 0.57735);
	float cosAngle = cos(angle);
	return aColor * cosAngle + cross(k, aColor) * sin(angle) + k * dot(k, aColor) * (1.0 - cosAngle);
}

vec3 applyHSBCEffect(vec3 color)
{
	color = clamp(color + ((brightness) / 255.0), 0.0, 1.0);

	color = applyHue(color, hue);

	color = clamp((color - 0.5) * (1.0 + ((contrast) / 255.0)) + 0.5, 0.0, 1.0);

	vec3 intensity = vec3(dot(color, vec3(0.30980392156, 0.60784313725, 0.08235294117)));
	color = clamp(mix(intensity, color, (1.0 + (saturation / 100.0))), 0.0, 1.0);

	return color;
}

vec4 flixel_texture2DCustom(sampler2D bitmap, vec2 coord)
{
	vec4 color = texture2D(bitmap, coord);
	color = vec4(color.rgb / color.a, color.a);
	color.rgb = applyHSBCEffect(color.rgb);
	color = vec4(color.rgb * color.a, color.a);
	if (!hasTransform) { return color; }

	if (color.a == 0.0) { return vec4(0.0, 0.0, 0.0, 0.0); }

	if (!hasColorTransform) { return color * openfl_Alphav; }

	color = vec4(color.rgb / color.a, color.a);
	color = clamp(openfl_ColorOffsetv + (color * openfl_ColorMultiplierv), 0.0, 1.0);

	if (color.a > 0.0) { return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav); }
	return vec4(0.0, 0.0, 0.0, 0.0);
}

void main()
{
	vec4 textureColor = flixel_texture2DCustom(bitmap, openfl_TextureCoordv);
	gl_FragColor = textureColor;
}