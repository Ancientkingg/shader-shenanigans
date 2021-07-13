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
in vec2 faceCoords;

out vec4 fragColor;

#define WIDTH 0.05
#define HIGHLIGHT vec4(1,0,0,1)
#define FREQ 1

void main() {
    float period = 0.5 * sin(GameTime * FREQ) + 0.5;
    vec4 tex = texture(Sampler0, texCoord0);
    if (tex.a * 255 == 254){
        tex *= ColorModulator * mix(vertexColor, vec4(1), 0.5 * cos(GameTime * FREQ) + 0.5);
    }else{
        tex *= vertexColor * ColorModulator;
    }
    fragColor = linear_fog(tex, vertexDistance, FogStart, FogEnd, FogColor);
    bool outline = faceCoords.x < WIDTH || faceCoords.x > (1 - WIDTH) || faceCoords.y < WIDTH || faceCoords.y > (1 - WIDTH);
    if (outline && tex.a * 255 == 254) fragColor = mix(fragColor, HIGHLIGHT, period);
}
