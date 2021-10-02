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

flat out float miniMap;
out vec3 position;
out vec2 uv;

#define mvm ModelViewMat
#define epsilon 0.01

float getFarClippingPlane(mat4 ProjMat) {
    vec4 distProbe = inverse(ProjMat) * vec4(0.0, 0.0, 1.0, 1.0);
    return length(distProbe.xyz / distProbe.w);
}

mat4 getOrthoMat(mat4 ProjMat, float Zoom) {
    float far = getFarClippingPlane(ProjMat);
    float near = 0.05; // Fixed distance that should never change
    float left = -(0.5 / (ProjMat[0][0] / (2.0 * near))) / Zoom;
    float right = -left;
    float top = (0.5 / (ProjMat[1][1] / (2.0 * near))) / Zoom;
    float bottom = -top;

    return mat4(2.0 / (right - left),               0.0,                                0.0,                            0.0,
                0.0,                                2.0 / (top - bottom),               0.0,                            0.0,
                0.0,                                0.0,                                -2.0 / (far - near),            0.0,
                -(right + left) / (right - left),   -(top + bottom) / (top - bottom),   -(far + near) / (far - near),   1.0);
}

void main() {
    position = Position + ChunkOffset;
    mat4 rotationMat = mvm;
    if(abs(mvm[1].z) > 0.99){
        vec3 right = mvm[0].xyz;
        right.z = 0;
        right = normalize(right);

        vec3 forward = mvm[2].xyz;
        forward.z = 0;
        forward = normalize(forward);

        vec3 temp = vec3(0,0,1);

        rotationMat[0].xyz = right;
        rotationMat[1].xyz = temp;
        rotationMat[2].xyz = forward;
    }else{
        vec3 right = ModelViewMat[0].xyz;
        right.y = 0;
        right = normalize(right);
        vec3 up = vec3(0, 1, 0);
        vec3 forward = cross(right, up);

        rotationMat = mat4(
            1, 0, 0, 0,
            0, 0, 1, 0,
            0, -1, 0, 0,
            0, 0, 0, 1
        ) * mat4(
            right, 0,
            up, 0,
            forward, 0,
            0, 0, 0, 1
        );
    }
    vec3 chunkoffset = ChunkOffset;
    chunkoffset.y = -10;
    miniMap = 0.0;
    // && abs(Position+ChunkOffset).y < 10
    if (abs(fract(Position.y) - 10./16.) < epsilon && texture(Sampler0, texCoord0).a * 255 != 254){
        miniMap = 1.0;
        gl_Position = getOrthoMat(ProjMat, 0.01) * rotationMat * vec4(Position + chunkoffset, 1.0);
        gl_Position.xy = gl_Position.xy * 0.2 - vec2(0.8,-0.6);
    }else{
        gl_Position = ProjMat * ModelViewMat * vec4(Position + ChunkOffset, 1.0);
    }
    uv = gl_Position.xy / gl_Position.w * 0.5 + 0.5;

    vertexDistance = length((ModelViewMat * vec4(Position + chunkoffset, 1.0)).xyz);
    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
