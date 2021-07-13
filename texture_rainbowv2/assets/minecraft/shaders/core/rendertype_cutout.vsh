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
    bool flag = false;
    
    if (Pos.x >= 480.0 && Pos.x < 496.0) { // lilac stem
        if (Pos.y >= 96.0 && Pos.y < 104.0) {
            flag = true;
        }
    }
    if (Pos.x >= 480.0 && Pos.x < 496.0) { // lilac top
        if (Pos.y >= 112.0 && Pos.y < 128.0) {
            flag = true;
        }
    }
    if (Pos.x >= 32.0 && Pos.x < 48.0) { // peony stem
        if (Pos.y >= 288.0 && Pos.y < 296.0) {
            flag = true;
        }
    }
    if (Pos.x >= 48.0 && Pos.x < 64.0) {
        if (Pos.y >= 288.0 && Pos.y < 304.0) { // peony top
            flag = true;
        }
    }
    if (Pos.x >= 160.0 && Pos.x < 176.0) { // tall grass
        if (Pos.y >= 384.0 && Pos.y < 392.0) {
            flag = true;
        }
    }
    if (Pos.x >= 32.0 && Pos.x < 96.0) { // sunflower
        if (Pos.y >= 384.0 && Pos.y < 400.0) {
            flag = true;
        }
    }
    if (Pos.x >= 48.0 && Pos.x < 64.0) { // sunflower stem
        if (Pos.y >= 398.0 && Pos.y < 400.0) {
            flag = false;
        }
    }
    if (Pos.x >= 176.0 && Pos.x < 192.0) { // tall grass
        if (Pos.y >= 384.0 && Pos.y < 400.0) {
            flag = true;
        }
    }
    if (Pos.x >= 320.0 && Pos.x < 448.0) { // wheat
        if (Pos.y >= 400.0 && Pos.y < 408.0) {
            flag = true;
        }
    }
    if (Pos.x >= 384.0 && Pos.x < 400.0) { // grass
        if (Pos.y >= 176.0 && Pos.y < 184.0) {
            flag = true;
        }
    }
    if (Pos.x >= 352.0 && Pos.x < 368.0) { // fern
        if (Pos.y >= 256.0 && Pos.y < 272.0) {
            flag = true;
        }
    }
    if (Pos.x >= 448.0 && Pos.x < 464.0) { // tall fern stem
        if (Pos.y >= 208.0 && Pos.y < 216.0) {
            flag = true;
        }
    }
    if (Pos.x >= 448.0 && Pos.x < 464.0) { // tall fern top
        if (Pos.y >= 224.0 && Pos.y < 240.0) {
            flag = true;
        }
    }
    if (Pos.x >= 288.0 && Pos.x < 304.0) { // dandelion
        if (Pos.y >= 16.0 && Pos.y < 26.0) {
            flag = true;
        }
    }
    if (Pos.x >= 336.0 && Pos.x < 352.0) { // red tulip
        if (Pos.y >= 320.0 && Pos.y < 328.0) {
            flag = true;
        }
    }
    if (Pos.x >= 96.0 && Pos.x < 112.0) { // poppy
        if (Pos.y >= 304.0 && Pos.y < 312.0) {
            flag = true;
        }
    }
    if (Pos.x >= 48.0 && Pos.x < 64.0) { // blue orchid
        if (Pos.y >= 160.0 && Pos.y < 168.0) {
            flag = true;
        }
    }
    if (Pos.x >= 32.0 && Pos.x < 48.0) { // allium
        if (Pos.y >= 128.0 && Pos.y < 134.0) {
            flag = true;
        }
    }
    if (Pos.x >= 16.0 && Pos.x < 32.0) { // cornflower
        if (Pos.y >= 256.0 && Pos.y < 264.0) {
            flag = true;
        }
    }
    if (Pos.x >= 112.0 && Pos.x < 176.0) { // glowberries
        if (Pos.y >= 208.0 && Pos.y < 224.0) {
            flag = true;
        }
    }
    if (Pos.x >= 192.0 && Pos.x < 224.0) { // tall seagrass
        if (Pos.y >= 384.0 && Pos.y < 400.0) {
            flag = true;
        }
    }
    if (Pos.x >= 496.0 && Pos.x < 512.0) { // seagrass
        if (Pos.y >= 336.0 && Pos.y < 352.0) {
            flag = true;
        }
    }
    if (Pos.x >= 448.0 && Pos.x < 464.0) { // kelp
        if (Pos.y >= 96.0 && Pos.y < 128.0) {
            flag = true;
        }
    }
    if (Pos.x >= 480.0 && Pos.x < 496.0) { // sporeblossom
        if (Pos.y >= 352.0 && Pos.y < 366.0) {
            flag = true;
        }
    }
    if (Pos.x >= 48.0 && Pos.x < 64.0) { // white tulip
        if (Pos.y >= 416.0 && Pos.y < 424.0) {
            flag = true;
        }
    }
    if (Pos.x >= 464.0 && Pos.x < 480.0) { // orange tulip
        if (Pos.y >= 272.0 && Pos.y < 280.0) {
            flag = true;
        }
    }
    if (Pos.x >= 192.0 && Pos.x < 208.0) { // pink tulip
        if (Pos.y >= 288.0 && Pos.y < 296.0) {
            flag = true;
        }
    }
    if (Pos.x >= 496.0 && Pos.x < 512.0) { // oxeye daisy
        if (Pos.y >= 272.0 && Pos.y < 280.0) {
            flag = true;
        }
    }
    if (Pos.x >= 480.0 && Pos.x < 496.0) { // lily of the valley
        if (Pos.y >= 128.0 && Pos.y < 136.0) {
            flag = true;
        }
    }
    if (Pos.x >= 192.0 && Pos.x < 208.0) { // azure bluet
        if (Pos.y >= 80.0 && Pos.y < 88.0) {
            flag = true;
        }
    }
    if (Pos.x >= 240.0 && Pos.x < 256.0) { // rose bottom
        if (Pos.y >= 336.0 && Pos.y < 344.0) {
            flag = true;
        }
    }
    if (Pos.x >= 256.0 && Pos.x < 272.0) { // rose top
        if (Pos.y >= 336.0 && Pos.y < 352.0) {
            flag = true;
        }
    }
    if (Pos.x >= 48.0 && Pos.x < 112.0) { // small dripleaf
        if (Pos.y >= 352.0 && Pos.y < 368.0) {
            flag = true;
        }
    }
    if (Pos.x >= 240.0 && Pos.x < 256.0) { // large dripleaf
        if (Pos.y >= 112.0 && Pos.y < 144.0) {
            flag = true;
        }
    }
    if (Pos.x >= 256.0 && Pos.x < 272.0) { // large dripleaf top
        if (Pos.y >= 0.0 && Pos.y < 16.0) {
            flag = true;
        }
    }
    if (Pos.x >= 368.0 && Pos.x < 384.0) { // flower azalea bush
        if (Pos.y >= 144.0 && Pos.y < 176.0) {
            flag = true;
        }
    }
    if (Pos.x >= 192.0 && Pos.x < 208.0) { // azalea bush
        if (Pos.y >= 48.0 && Pos.y < 80.0) {
            flag = true;
        }
    }
    if (Pos.x >= 192.0 && Pos.x < 208.0) { // bamboo leaves
        if (Pos.y >= 96.0 && Pos.y < 144.0) {
            flag = true;
        }
    }
    if (Pos.x >= 208.0 && Pos.x < 224.0) { // bamboo stem
        if (Pos.y >= 16.0 && Pos.y < 32.0) {
            flag = true;
        }
    }
    if (Pos.x >= 480.0 && Pos.x < 496.0) { // lilypad
        if (Pos.y >= 144.0 && Pos.y < 160.0) {
            flag = true;
        }
    }
    if (Pos.x >= 0.0 && Pos.x < 16.0) { // vine
        if (Pos.y >= 400.0 && Pos.y < 416.0) {
            flag = true;
        }
    }

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

    if (Pos.x >= 112.0 && Pos.x < 176.0) { // glowberries
        if (Pos.y >= 208.0 && Pos.y < 224.0) {
            xs = 0;
            zs = 0;
        }
    }
    if (Pos.x >= 448.0 && Pos.x < 464.0) { // kelp
        if (Pos.y >= 96.0 && Pos.y < 128.0) {
            xs = 0;
            zs = 0;
            ys = 0;
        }
    }
    if (Pos.x >= 192.0 && Pos.x < 224.0) { // tall seagrass
        if (Pos.y >= 384.0 && Pos.y < 400.0) {
            xs = 0;
            zs = 0;
            ys = 0;
        }
    }
    if (Pos.x >= 496.0 && Pos.x < 512.0) { // seagrass
        if (Pos.y >= 336.0 && Pos.y < 352.0) {
            xs = 0;
            zs = 0;
            ys = 0;
        }
    }
    if (Pos.x >= 48.0 && Pos.x < 112.0) { // small dripleaf
        if (Pos.y >= 352.0 && Pos.y < 368.0) {
            xs = 0;
            zs = 0;
            ys = 0;
        }
    }
    if (Pos.x >= 240.0 && Pos.x < 256.0) { // large dripleaf
        if (Pos.y >= 112.0 && Pos.y < 144.0) {
            xs = 0;
            zs = 0;
            ys = 0;
        }
    }
    if (Pos.x >= 256.0 && Pos.x < 272.0) { // large dripleaf top
        if (Pos.y >= 0.0 && Pos.y < 16.0) {
            xs = 0;
            zs = 0;
            ys = 0;
        }
    }
    if (Pos.x >= 368.0 && Pos.x < 384.0) { // flower azalea bush
        if (Pos.y >= 144.0 && Pos.y < 176.0) {
            xs = 0;
            zs = 0;
            ys = 0;
        }
    }
    if (Pos.x >= 192.0 && Pos.x < 208.0) { // azalea bush
        if (Pos.y >= 48.0 && Pos.y < 80.0) {
            xs = 0;
            zs = 0;
            ys = 0;
        }
    }
    if (Pos.x >= 208.0 && Pos.x < 224.0) { // bamboo stem
        if (Pos.y >= 16.0 && Pos.y < 32.0) {
            xs = 0;
            zs = 0;
            ys = 0;
        }
    }
    if (Pos.x >= 480.0 && Pos.x < 496.0) { // lilypad
        if (Pos.y >= 144.0 && Pos.y < 160.0) {
            xs = 0;
            zs = 0;
            ys = 0;
        }
    }

    gl_Position = ProjMat * ModelViewMat * (vec4(position, 1.0) + vec4(xs / 32.0, ys / 32.0, zs / 32.0, 0.0));

    vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
    vertexColor = (Color + rgba) * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}