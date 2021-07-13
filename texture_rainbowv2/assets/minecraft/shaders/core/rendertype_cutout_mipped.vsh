#version 150

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;
uniform float GameTime;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

void main() {
    vec3 position = Position + ChunkOffset;
    float animation = GameTime * 1000.0;
    vec2 Pos = UV0*1024;

    float xs = 0.0;
    float zs = 0.0;
    float ys = 0.0;
    bool flag = true;


    vec4 rgba = vec4(0.0);
    if (flag) {
        xs = sin(position.x + animation);
        zs = cos(position.z + animation);
        ys = sin(position.x + animation) * cos(position.z + animation);

        vec3 hsl = vec3(mod(-position.y * 0.1 + GameTime * 100, 1.0), 1.0, 1.0);
        vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
        vec3 p = abs(fract(hsl.xxx + K.xyz)*6.0 - K.www);

        vec3 rgb = hsl.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), hsl.y);
        rgba = vec4(rgb, 0.0);
    }

    gl_Position = ProjMat * ModelViewMat * (vec4(position, 1.0) + vec4(xs / 32.0, ys / 32.0, zs / 32.0, 0.0));

    vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
    vertexColor = (Color + rgba) * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
