#version 150

in vec3 Position;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform float LineWidth;
uniform vec2 ScreenSize;
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;

mat4 rotate(float angle){
    return mat4(
         cos(angle), -sin(angle),  0.0, 0.0,
         sin(angle), cos(angle),  0.0, 0.0,
                0.0,        0.0,  1.0, 0.0,
                0.0,        0.0,  0.0, 1.0);
}

mat3 rotateZ(float angle){
    return mat3(
         cos(angle), -sin(angle),  0.0,
         sin(angle), cos(angle),  0.0,
                0.0,        0.0,  1.0);
}

const float VIEW_SHRINK = 1.0 - (1.0 / 256.0);
const mat4 VIEW_SCALE = mat4(
    VIEW_SHRINK, 0.0, 0.0, 0.0,
    0.0, VIEW_SHRINK, 0.0, 0.0,
    0.0, 0.0, VIEW_SHRINK, 0.0,
    0.0, 0.0, 0.0, 1.0
);

void main() {
    float angle = GameTime*1500;
    mat4 M = rotate(angle) * ModelViewMat;
    vec3 pos = Position;
    if (Position.z >= 0){
        pos = rotateZ(angle) * Position;
        M = ModelViewMat;
    }
    vec4 linePosStart = ProjMat * VIEW_SCALE * M * vec4(pos, 1.0);
    vec4 linePosEnd = ProjMat * VIEW_SCALE * M * vec4(pos + Normal, 1.0);

    vec3 ndc1 = linePosStart.xyz / linePosStart.w;
    vec3 ndc2 = linePosEnd.xyz / linePosEnd.w;

    vec2 lineScreenDirection = normalize((ndc2.xy - ndc1.xy) * ScreenSize);
    vec2 lineOffset = vec2(-lineScreenDirection.y, lineScreenDirection.x) * LineWidth / ScreenSize;

    if (lineOffset.x < 0.0) {
        lineOffset *= -1.0;
    }

    if (gl_VertexID % 2 == 0) {
        gl_Position = vec4((ndc1 + vec3(lineOffset, 0.0)) * linePosStart.w, linePosStart.w);
    } else {
        gl_Position = vec4((ndc1 - vec3(lineOffset, 0.0)) * linePosStart.w, linePosStart.w);
    }

    vertexDistance = length((M * vec4(pos, 1.0)).xyz);
    vertexColor = Color;
}
