#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D TexSampler;
uniform sampler2D AuxSampler;

in vec2 texCoord;
in vec2 oneTexel;

uniform vec2 ScreenSize;
uniform vec2 CharSize;
uniform float Time;

out vec4 fragColor;

#define RED vec4(1,0,0,1)
#define twoPI 6.2831853

/* 
Size of letter 35x49 
Space between rows 15 pixels
*/

vec4 putChar(int charIndex, vec2 screenCoords, float scale)
{

    bool con1 = texCoord.x > screenCoords.x && texCoord.y > screenCoords.y + 2.0 / ScreenSize.y;
    bool con2 = texCoord.x < (screenCoords.x + 35.0 * scale / ScreenSize.x) && texCoord.y < (screenCoords.y + 48.9 * scale / ScreenSize.y);
    if (con1 && con2){
        vec2 offset;
        offset.x = charIndex % 12;
        offset.y = (charIndex - offset.x) / 12;
        offset *= vec2(35.0 / textureSize(TexSampler, 0).x, 49.0 / textureSize(TexSampler, 0).y);
        vec2 SamplerScale = ScreenSize / textureSize(TexSampler, 0) / scale;
        vec2 coords = texCoord - screenCoords;
        coords *= SamplerScale;
        coords.y = (49.0 / textureSize(TexSampler, 0).y) - coords.y; // flips the character so it's displayed correctly
        vec4 tex = texture(TexSampler, coords + offset);
        return tex;
    }
    return vec4(0);
}

vec4 putStr(int str[8], vec2 screenCoords, float scale, float offset)
{
    vec4 tex = vec4(0);
    for (int i = 0; i < 8; i++)
    {
        tex += putChar(str[i], screenCoords, scale);
        screenCoords.x += (35.0 * scale + offset) / ScreenSize.x;
    }
    return tex;
}

const float range = 0.05;
const float noiseQuality = 250.0;
const float noiseIntensity = 0.0088;
const float offsetIntensity = 0.02;
const float colorOffsetIntensity = 1.3;

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float verticalBar(float pos, float uvY, float offset)
{
    float edge0 = (pos - range);
    float edge1 = (pos + range);

    float x = smoothstep(edge0, pos, uvY) * offset;
    x -= smoothstep(pos, edge1, uvY) * offset;
    return x;
}


void main() 
{
    float time = Time * twoPI;
    vec4 text = putStr(int[8](15,11,0,24,38,40,40,40), vec2(0.1, 0.85), 1.3, 6);
    vec2 uv = texCoord;
    
    for (float i = 0.0; i < 0.71; i += 0.1313)
    {
        float d = mod(Time * texture(AuxSampler, vec2(0.1)).r * 10 * i, 1.7);
        float o = sin(1.0 - tan(time * 0.05 * 0.24 * i));
    	o *= offsetIntensity;
        uv.x += verticalBar(d, uv.y, o);
    }
    
    float uvY = uv.y;
    uvY *= noiseQuality;
    uvY = float(int(uvY)) * (1.0 / noiseQuality);
    float noise = rand(vec2(time * 0.00001, uvY));
    uv.x += noise * noiseIntensity;

    vec2 offsetR = vec2(0.003 * sin(time), 0.0) * colorOffsetIntensity;
    vec2 offsetG = vec2(0.0045 * (cos(time * 0.97)), 0.0) * colorOffsetIntensity;
    
    float r = texture(DiffuseSampler, uv + offsetR).r;
    float g = texture(DiffuseSampler, uv + offsetG).g;
    float b = texture(DiffuseSampler, uv).b;

    vec4 tex = vec4(r, g, b, 1.0);
    
    fragColor = mix(tex, text, text.a); // by mixing it you can overlay stuff
}
