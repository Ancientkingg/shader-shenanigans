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
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;
out vec3 position;

vec3 czm_saturation(vec3 rgb, float adjustment)
{
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

void main() {
    position = Position + ChunkOffset;
    float animation = GameTime * 4000.0;

    float xs = 0.0;
    float zs = 0.0;
    if (texture(Sampler0, UV0).a * 255 == 253.0 || (gl_VertexID % 4 == 0 && texture(Sampler0, vec2(UV0.x, UV0.y + 1.0 / textureSize(Sampler0, 0).y)).a * 255 == 253.0) || (gl_VertexID % 4 == 2 && texture(Sampler0, vec2(UV0.x, UV0.y - 1.0 / textureSize(Sampler0, 0).y)).a * 255 == 253.0)) {
        xs = sin(position.x + animation);
        zs = cos(position.z + animation);

    }

    gl_Position = ProjMat * ModelViewMat * (vec4(position, 1.0) + vec4(xs / 32.0, 0.0, zs / 32.0, 0.0));

    vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
    vertexColor = vec4(czm_saturation(Color.rgb, 2.5),Color.a) * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
