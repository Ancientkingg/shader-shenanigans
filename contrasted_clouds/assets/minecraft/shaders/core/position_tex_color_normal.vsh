#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;
out float vertexDistance;
out vec4 vertexColor;
out vec3 normal;
out vec3 position;

#define RED vec4(1,0,0,1)

void main() {
    texCoord0 = UV0;
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = Color;
    position = Position;
    normal = Normal;
    if (Normal == vec3(1,0,0) || Normal == vec3(-1,0,0)) vertexColor *= 1.7;
    if (Normal == vec3(0,0,1) || Normal == vec3(0,0,-1)) vertexColor *= 0.7;
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
}
