#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform float GameTime;

out vec2 texCoord0;
out float vertexDistance;
out vec4 vertexColor;
out vec4 normal;

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

    texCoord0 = UV0;
    vertexDistance = length((M * vec4(Position, 1.0)).xyz);
    vertexColor = Color;
    normal = ProjMat * M * vec4(Normal, 0.0);
}
