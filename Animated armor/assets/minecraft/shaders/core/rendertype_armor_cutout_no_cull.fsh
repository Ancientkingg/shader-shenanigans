#version 150

#moj_import <fog.glsl>
#moj_import <light.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;

out vec4 fragColor;

#define TEX_RES 16
#define ANIM_SPEED 1200
#define pi 3.14159


void main() {
    ivec2 atlasSize = textureSize(Sampler0, 0);
    vec2 pixelSize = 1.0 / atlasSize;
    vec2 coords = texCoord0;
    float maxFrames = atlasSize.y / (TEX_RES * 2.0);
    coords.y /= maxFrames;
    float interpolClock = 0;
    vec2 nextFrame = vec2(0);
    // texture properties contains extra info about the armor texture, such as to enable shading
    vec4 animInfo = texture(Sampler0, vec2(0, 0)) * 255;
    vec4 textureProperties = texture(Sampler0, vec2(0 + pixelSize.x, 0)) * 255;
    if (animInfo != vec4(0,0,0,0)){
        // oh god it's animated
        // animInfo = amount of frames, speed, interpolation (1||0)
        // fract(GameTime * 1200) blinks every second so [0,1] every second
        float timer = floor(mod(GameTime * ANIM_SPEED * animInfo.g, animInfo.r));
        if (animInfo.b > 0) interpolClock = fract(GameTime * ANIM_SPEED * animInfo.g);
        float v_offset = (TEX_RES * 2.0) / atlasSize.y * timer;
        nextFrame = coords;
        coords.y += v_offset;
        nextFrame.y += (TEX_RES * 2.0) / atlasSize.y * mod(timer + 1, animInfo.r);
    }
    vec4 vtc;
    if (textureProperties.r != 0){
        vtc = vec4(1);
    }else{
        vtc = vertexColor;
    }
    
    vec4 armor = mix(texture(Sampler0, coords), texture(Sampler0, nextFrame), interpolClock);
    vec4 color = armor * vtc * ColorModulator;
    if (color.a < 0.1) discard;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
