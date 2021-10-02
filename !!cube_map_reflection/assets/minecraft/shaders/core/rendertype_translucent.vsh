#version 150

#moj_import <light.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec3 normal;
out vec3 position;
out vec2 faceCoords;
out vec3 flat_Normal;
out vec4 lightlevel;
out float skylevel;

vec2 generateFaceCoords(){
    if (gl_VertexID % 4 == 0) return vec2(0.0,0.0);
    else if (gl_VertexID % 4 == 1) return vec2(0.0,1.0);
    else if (gl_VertexID % 4 == 2) return vec2(1.0,1.0);
    else if (gl_VertexID % 4 == 3) return vec2(1.0,0.0);
}

#define RED vec4(1,0,0,1)

void main() {
    skylevel = UV2.y;
    flat_Normal = Normal;
    // changed this but untested so if it breaks, remove the texture()
    if (Normal == vec3(0,1,0)){
        position = Position + ChunkOffset;
        faceCoords = generateFaceCoords();
        float animation = GameTime * 4000.0;

        float xs = 0.0;
        float ys = 0.0;
        float zs = 0.0;
        float m0 = (distance(Position.xz, vec2(8,8)) + 1) * 10;
        xs = sin(position.x + animation) * cos(GameTime * 300);
        ys = cos(m0 + animation) * 1.25;
        zs = cos(position.z + animation) * sin(GameTime * 300);
        gl_Position = ProjMat * ModelViewMat * (vec4(position, 1.0) + vec4(xs / 32.0, ys / 16, zs / 32.0, 0.0));

        vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
        vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
        lightlevel = texture(Sampler2, vec2(0,1));
        texCoord0 = UV0;
        normal = Normal;
        vec3 fx = vec3(cos(position.x + animation) * 0.5 / 32.0, -0.078125 * (position.x-8) *sin(animation + m0)/m0, 0) + vec3(1, 0, 0);
        vec3 fz = vec3(0, -0.078125 * (position.z-8) *sin(animation+m0)/m0, -sin(position.z + animation) * 0.5) + vec3(0, 0, 1);
        vec3 surfaceNormal = cross(fx,fz);
        normal = normalize(surfaceNormal);
    }else{
        gl_Position = ProjMat * ModelViewMat * vec4(Position + ChunkOffset, 1.0);

        vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
        vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
        texCoord0 = UV0;
        normal = vec3(-1);
    }
    
}
