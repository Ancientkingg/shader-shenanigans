#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec2 ScreenSize;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 normal;
in vec2 faceCoords;

out vec4 fragColor;

#define TEX_RES 16
#define SCALE 8

void main() {
    float animation = GameTime * 100000;
    vec2 offset = floor((texCoord0) * textureSize(Sampler0, 0) / 16.0) * 16.0;
    
    ivec2 coords = ivec2(mod(vec2(gl_FragCoord.x, ScreenSize.y - gl_FragCoord.y)/ SCALE, TEX_RES) + offset);
    vec4 color = texelFetch(Sampler0, coords, 0) * vertexColor;
    if (color.a < 0.5) discard;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
