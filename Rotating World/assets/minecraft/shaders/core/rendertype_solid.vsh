#version 150

#moj_import <light.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

mat4 rotate(float angle){
    return mat4(
         cos(angle), -sin(angle),  0.0, 0.0,
         sin(angle), cos(angle),  0.0, 0.0,
                0.0,        0.0,  1.0, 0.0,
                0.0,        0.0,  0.0, 1.0);
}

void main() {
    // float angle = GameTime * 500;
    float angle = GameTime*1500;
    mat4 M = rotate(angle) * ModelViewMat;
    gl_Position = ProjMat * M * vec4(Position + ChunkOffset, 1.0);

    vertexDistance = length((M * vec4(Position + ChunkOffset, 1.0)).xyz);
    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = ProjMat * M * vec4(Normal, 0.0);
}
