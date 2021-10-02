#version 150

in vec3 Position;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform float GameTime;

out vec2 texCoord0;

mat4 rotate(float angle){
    return mat4(
         cos(angle), -sin(angle),  0.0, 0.0,
         sin(angle), cos(angle),  0.0, 0.0,
                0.0,        0.0,  1.0, 0.0,
                0.0,        0.0,  0.0, 1.0);
}

void main() {
    float angle = GameTime*1500;
    mat4 M = ModelViewMat;
    if (abs(length(Position) - 109) < 0.5 || abs(length(Position) - 104) < 0.5) M = rotate(angle) * ModelViewMat;
    // if (length(Position) > 109 || length(Position) < 108) M = ModelViewMat;
    gl_Position = ProjMat * M * vec4(Position, 1.0);
    texCoord0 = UV0;
}
