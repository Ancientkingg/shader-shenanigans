#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec4 normal;
in vec3 position;

out vec4 fragColor;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.1) {
        discard;
    }
    color *= vertexColor * ColorModulator;
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
    color *= lightMapColor;
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec4 gray_color = vec4(gray,gray,gray,color.a);
    float distance = 4 + rand(position.xy) * 2;
    if (length(position) > distance){
        fragColor = linear_fog(gray_color, vertexDistance, FogStart, FogEnd, gray_color);
    }else{
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, gray_color);
    }
}
