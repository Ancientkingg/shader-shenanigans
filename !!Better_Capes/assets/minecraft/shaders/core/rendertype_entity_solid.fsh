#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec4 normal;
in vec2 uv;

out vec4 fragColor;

#define RED vec4(1,0,0,1)
#define DETAIL 8
#define EPSILON 0.01
#define OFFSET1 0.5
#define OFFSET2 1


// Smooth HSV to RGB conversion 
vec3 hsv2rgb_smooth( in vec3 c )
{
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

	rgb = rgb*rgb*(3.0-2.0*rgb); // cubic smoothing	

	return c.z * mix( vec3(1.0), rgb, c.y);
}

vec4 rgb(float r, float g, float b)
{
    return vec4(r,g,b,255) / 255.;
}

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    bool bool1 = textureSize(Sampler0, 0) == ivec2(64,32);
    if (bool1){
	
        float anim = GameTime * 300;
	    vec3 hsl1 = vec3( texCoord0.x+anim*0.1, 1.0, OFFSET1 );
        vec3 hsl2 = vec3( texCoord0.x-anim*0.1, 1.0, OFFSET2 );
	
        vec4 color1 = vec4(1.0, 0.55, 0.0, 1.0);
        vec4 color2 = vec4(0.226,0.000,0.615, 1.0);
        // color1 = rgb(128,0,128);
        // color2 = rgb(255,215,0);
        color1 = vec4(hsv2rgb_smooth( hsl1 ), 1.0);
        color2 = vec4(hsv2rgb_smooth( hsl2 ), 1.0);
        vec2 coords = texCoord0;
        // coords.y = floor((coords.y - anim) * DETAIL) / DETAIL;
        coords.y = coords.y - anim;
        float mixValue = fract(length(coords));
        mixValue += abs((texCoord0.x + sin((anim+texCoord0.y)*10)*0.05) - 0.09375)*20;
        color = mix(color1,color2,sin(mixValue*6.28));
    }else{
        color *= vertexColor * ColorModulator;
        color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
        color *= lightMapColor;
    }
    
    
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
