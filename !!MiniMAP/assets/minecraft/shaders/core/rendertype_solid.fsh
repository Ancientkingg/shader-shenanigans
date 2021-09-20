#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 normal;
in vec3 position;
flat in float miniMap;
in vec2 uv;

out vec4 fragColor;

#define BORDER 0.01
#define SIZE 0.15
#define COORDS vec2(0.15,0.85)

#define epsilon 0.1

void main() {
    if (texture(Sampler0, texCoord0).a * 255 == 254) miniMap == 0.0;
    float verticalRes = 1. / uv.y * gl_FragCoord.y;
    vec2 n_uv = gl_FragCoord.xy / verticalRes;
    if (miniMap == 1.0 && distance(COORDS, n_uv) > SIZE) discard; 
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.5) discard;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    if (length(position.xz) < 0.2 && miniMap == 1.0) fragColor = vec4(1);
    if (miniMap == 1.0 && abs(distance(COORDS, n_uv) - SIZE) < BORDER) fragColor = vec4(0);
    if (miniMap != 1.0 && distance(COORDS, n_uv) < SIZE) fragColor = color * 0.5;
    // gl_FragDepth = gl_FragCoord.z;
    // if (miniMap == 1.0){
    //     gl_FragDepth = -position.y-10;
    // }
        // fragColor = vec4(length(position)/50.);
}
