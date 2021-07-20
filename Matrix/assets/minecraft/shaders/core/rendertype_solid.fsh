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
in vec2 texCoord0;
in vec4 normal;
in vec3 distance;
in vec2 faceCoords;
in vec3 position;

out vec4 fragColor;

#define THICKNESS 0.1
#define FAR 500
#define LINE_FREQ 8
// #define COLOR rgb(24,202,230)
#define COLOR vec3(0,1,0)


vec3 rgb(float r, float g, float b){
    return vec3(r,g,b) / 255.;
}

void main() {
    float animation = GameTime * 3650;
    vec4 color;
    color = vec4(0);
    bool edge = abs(0.5 - mod(position.x, LINE_FREQ)) < THICKNESS || abs(0.5 - mod(position.z, LINE_FREQ)) < THICKNESS;
    if (edge) color = vec4(COLOR,1);
    fragColor = linear_fog(color, vertexDistance, FogStart - vertexDistance, FogEnd, vec4(COLOR,vertexDistance/FAR));

    // without fog
    // fragColor = color;
}
