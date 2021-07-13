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
flat in vec3 chunkoffset;

out vec4 fragColor;

#define RED vec4(1,0,0,1)

void main() {
    if (chunkoffset.x <= -16 || chunkoffset.x > 0 || chunkoffset.z <= -16 || chunkoffset.z > 0) discard;
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.5) discard;
    color *= vertexColor * ColorModulator;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
