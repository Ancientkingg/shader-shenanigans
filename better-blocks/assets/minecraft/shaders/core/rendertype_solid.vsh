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

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
flat out vec3 normal;
out vec3 position;
out vec2 faceCoords;
out vec4 lightlevel;

vec2 generateFaceCoords(){
    if (gl_VertexID % 4 == 0) return vec2(0.0,0.0);
    else if (gl_VertexID % 4 == 1) return vec2(0.0,1.0);
    else if (gl_VertexID % 4 == 2) return vec2(1.0,1.0);
    else if (gl_VertexID % 4 == 3) return vec2(1.0,0.0);
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position + ChunkOffset, 1.0);
    position = Position + ChunkOffset;
    vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = Normal;
    faceCoords = generateFaceCoords();
    lightlevel = texture(Sampler2, vec2(0,1));
}
