#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform float GameTime;

out float vertexDistance;
out vec2 texCoord0;
out vec4 vertexColor;

mat4 rotate(float angle){
    return mat4(
         cos(angle), -sin(angle),  0.0, 0.0,
         sin(angle), cos(angle),  0.0, 0.0,
                0.0,        0.0,  1.0, 0.0,
                0.0,        0.0,  0.0, 1.0);
}

void main() {
    float angle = GameTime*1500;
    mat4 M = rotate(angle) * ModelViewMat;
    gl_Position = ProjMat * M * vec4(Position, 1.0);

    vertexDistance = length((M * vec4(Position, 1.0)).xyz);
    texCoord0 = UV0;
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
}
