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
out vec2 texCoord2;
out vec4 normal;

void main() {
    vec3 position = Position + ChunkOffset;
    float animation = GameTime * 1000.0;

    float xs = 0.0;
    float zs = 0.0;
    float modifiedRed = 0.0;
    float modifiedGreen = 0.0;
    float modifiedBlue = 0.0;
    bool flag = true;

    if (flag) {
        xs = sin(position.x + animation);
        zs = cos(position.z + animation);
        modifiedRed = sin((position.x + animation) / 8);
        modifiedGreen = sin((position.y + animation) / 8);
        modifiedBlue = sin((position.z + animation) / 8);
    }

    gl_Position = ProjMat * ModelViewMat * (vec4(position, 1.0) + vec4(0.0, (xs - zs) / 32.0, 0.0, 0.0));

    vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
//    vertexColor = (Color + vec4(modifiedRed * modifiedRed, modifiedGreen * modifiedGreen, modifiedBlue * modifiedBlue, 0.0)) * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
