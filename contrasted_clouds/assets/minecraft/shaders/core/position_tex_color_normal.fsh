#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in vec2 texCoord0;
in float vertexDistance;
in vec4 vertexColor;
in vec3 normal;
in vec3 position;

out vec4 fragColor;

#define RED vec4(1,0,0,1)

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 color;
    if (rand(round(texCoord0 * 512.0)) < 0) color = texture(Sampler0, texCoord0) * (vertexColor * 0.95) * ColorModulator;
    else color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) discard;
    if (normal.y == 0) color *= 0.5 * fract(position.y / 4.0) + 0.5;
    if (normal.y < 0) color.a = 0.25;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    
}
