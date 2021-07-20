#version 150

// Credit to bradleyq for sky shader. Link: https://github.com/bradleyq/shader-toolkit

#moj_import <fog.glsl>

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec2 ScreenSize;

in mat4 ProjInv;
in float isSky;
in float vertexDistance;

out vec4 fragColor;

#define GRIDOFFSET 0.078
#define GRIDDENSITY 10.0
// #define COLOR rgb(24,202,230)
#define COLOR vec3(0,1,0)

vec3 rgb(float r, float g, float b){
    return vec3(r,g,b) / 255.;
}

void main() {
    // get player space view vector
    vec4 screenPos = gl_FragCoord;
    screenPos.xy = (screenPos.xy / ScreenSize - vec2(0.5)) * 2.0;
    screenPos.zw = vec2(1.0);
    vec3 view = normalize((ProjInv * screenPos).xyz);

    float vdn = dot(view, vec3(0.0, 1.0, 0.0));
    float vdt = dot(view, vec3(1.0, 0.0, 0.0));
    float vdb = dot(view, vec3(0.0, 0.0, 1.0));
    fragColor = mix(vec4(0),vec4(COLOR,1),0.8-vdn*1.5);
}
