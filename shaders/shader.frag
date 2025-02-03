// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
#define texture flixel_texture2D

// third argument fix
vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
	vec4 color = texture2D(bitmap, coord, bias);
	if (!hasTransform)
	{
		return color;
	}
	if (color.a == 0.0)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	if (!hasColorTransform)
	{
		return color * openfl_Alphav;
	}
	color = vec4(color.rgb / color.a, color.a);
	mat4 colorMultiplier = mat4(0);
	colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
	colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
	colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
	colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
	color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
	if (color.a > 0.0)
	{
		return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
	}
	return vec4(0.0, 0.0, 0.0, 0.0);
}

// variables which is empty, they need just to avoid crashing shader
uniform float iTimeDelta;
uniform float iFrameRate;
uniform int iFrame;
#define iChannelTime float[4](iTime, 0., 0., 0.)
#define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))
uniform vec4 iMouse;
uniform vec4 iDate;

#define PI 3.1415926538
float sosSpin(float amp, float freq, float shift, vec2 uv, float spin)
{
    return amp * sin( freq * ((spin * (length(uv)-(atan(uv.x,uv.y) / spin))) + shift));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord/iResolution.y * 2.)-vec2(iResolution.x/iResolution.y,1.);

    // Time varying pixel color
    vec3 col = vec3(1.,1.,1.);
    
    float spin = 3. * PI;
    
    //sum of sines
    float sos = sosSpin(2.,1.,0.5 * iTime,uv,spin);
    sos += sosSpin(1.5,2.,3. * iTime,uv,spin);
    sos += sosSpin(2.,5.,1.286 * iTime,uv,spin);
    sos += sosSpin(.5,8.,2. * iTime,uv,spin);
    sos += sosSpin(2.5,7.,1. * iTime,uv,spin);
    //if(sos > 0.) col = vec3(0.,0.,0.);
    col = vec3(sos,0.,0.) / 2.;
    
    //sum of sines but neg spin
    float sos2 = sosSpin(2.,1.,0.5 * iTime,uv,-spin);
    sos2 += sosSpin(1.5,2.,3. * iTime,uv,-spin);
    sos2 += sosSpin(2.,5.,1.286 * iTime,uv,-spin);
    sos2 += sosSpin(.5,8.,2. * iTime,uv,-spin);
    sos2 += sosSpin(2.5,7.,1. * iTime,uv,-spin);
    
    col += vec3(sos2,0.,0.) / 2.;
    
    // Output to screen
    fragColor = vec4(col,texture(iChannel0, uv).a);
    
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}