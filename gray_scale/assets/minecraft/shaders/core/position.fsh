#version 150

#moj_import <fog.glsl>

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;

out vec4 fragColor;

void main() {
    float gray = dot(ColorModulator.rgb, vec3(0.299, 0.587, 0.114));
    vec4 gray_color = vec4(gray,gray,gray,ColorModulator.a);
    fragColor = gray_color;
}
