#version 150

#moj_import <light.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;
out vec2 faceCoords;

vec2 generateFaceCoords(){
    if (gl_VertexID % 4 == 0) return vec2(0.0,1.0);
    else if (gl_VertexID % 4 == 1) return vec2(0.0,0.0);
    else if (gl_VertexID % 4 == 2) return vec2(1.0,0.0);
    else if (gl_VertexID % 4 == 3) return vec2(1.0,1.0);
}

void main() {
    vec4 tex = texture(Sampler0, UV0);
    if (tex.a * 255 == 254){
        gl_Position = ProjMat * ModelViewMat * vec4(Position + ChunkOffset, 16.0);
    }else{
        gl_Position = ProjMat * ModelViewMat * vec4(Position + ChunkOffset, 1.0);
    }

    vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    faceCoords = generateFaceCoords();
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
