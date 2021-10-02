#version 150

#moj_import <fog.glsl>

#moj_import <light.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec3 normal;
in vec3 position;
in vec2 faceCoords;
in vec4 lightlevel;
in vec4 lightMapColor;
in vec4 overlayColor;


out vec4 fragColor;

#define RED vec4(1,0,0,1)


vec4 sampleCubeMap(vec3 vector, ivec2 origin, ivec2 cubemapSize){
    vec3 dir = vector;
    float maxDir = max(abs(vector.x), max(abs(vector.y), abs(vector.z)));
    vec3 absDir = abs(vector);
    dir = dir / maxDir;
    ivec2 newOrigin = origin;
    if (maxDir == absDir.x){
        // what to do when it hit one of the x-sides
        newOrigin.y -= int((cubemapSize.y / 3) * sign(dir.x));
        ivec2 coords = newOrigin + ivec2(dir.z * (cubemapSize.y / 6) * -1, dir.y * (cubemapSize.y / 6) * sign(dir.x));
        return texelFetch(Sampler0, coords, 0);
    }else if (maxDir == absDir.y){
        // what to do when it hit the bottom/top
        if (dir.y < 0) newOrigin.x += int((cubemapSize.y / 3) * 2);
        ivec2 coords = newOrigin - ivec2(dir.z * (cubemapSize.y / 6) * int(sign(dir.y)), dir.x * (cubemapSize.y / 6));
        return texelFetch(Sampler0, coords, 0);
    }else if (maxDir == absDir.z){
        // what to do when it hit the z-sides
        newOrigin.x -= int((cubemapSize.y / 3) * sign(dir.z));
        ivec2 coords = newOrigin + ivec2(dir.y * (cubemapSize.y / 6) * sign(dir.z), dir.x * (cubemapSize.y / 6) * -1);
        return texelFetch(Sampler0, coords, 0);
    }
}

vec4 rgb(float r, float g, float b){
    return vec4(r / 255., g / 255., b / 255., 1);
}




void main() {
    vec2 atlasSize = textureSize(Sampler0, 0);
    const ivec2 cubemapSize = ivec2(816,306);
    ivec2 topleft = ivec2(texCoord0 * atlasSize - faceCoords * cubemapSize * 0.999);
    if (texture(Sampler0, (vec2(texCoord0 * atlasSize - faceCoords * cubemapSize * 0.999) + vec2(0, cubemapSize.y - 0.5)) / atlasSize) == vec4(1,0,0,1)){
        ivec2 origin = topleft + (cubemapSize.y / 2);
        ivec2 origin_2 = origin;
        origin_2.x += (cubemapSize.y * 4 / 3);
        vec3 vector = reflect(position, normal);
        vec4 reflection = sampleCubeMap(vector, origin, cubemapSize) * 0.8;
        vec4 reflection_night = sampleCubeMap(vector, origin_2, cubemapSize) * 1.5;
        reflection = mix(reflection, reflection_night, smoothstep(0.8, 0.6, lightlevel.r));
        int index = int(floor(fract(GameTime * 600) * 31));
        // columns, rows
        ivec2 waterCoords = topleft + ivec2(faceCoords * 16);
        vec4 blockTex = texelFetch(Sampler0, waterCoords, 0);
        if (blockTex.a < 0.1) discard;
        blockTex *= (vertexColor * 0.5 + 0.35) * ColorModulator;
        blockTex.rgb = mix(overlayColor.rgb, blockTex.rgb, overlayColor.a);
        float f0 = 0.195;
        float factor = pow(1 - dot(abs(normal), abs(normalize(position))),1) * texelFetch(Sampler0, topleft + ivec2(faceCoords * 16) + ivec2(16, 0), 0).r;
        blockTex = mix(blockTex, reflection, factor+0.15 + smoothstep(0.8, 0.6, lightlevel.r)*0.3*texelFetch(Sampler0, topleft + ivec2(faceCoords * 16) + ivec2(16, 0), 0).r);

        // specular attempt lol
        // float specularStrength = 2;
        float specularStrength = texelFetch(Sampler0, topleft + ivec2(faceCoords * 16) + ivec2(16, 0), 0).r * 2;
        vec3 lightDir = normalize(vec3(0.5*sign(normal.z+0.1)*sign(normal.x+0.1),0.5,0.5*sign(normal.z+0.1)*sign(normal.x+0.1)));
        vec3 viewDir = normalize(position);
        vec3 reflectDir = reflect(lightDir, abs(normal));

        float spec = pow(max(dot(viewDir, reflectDir), 0.0), 8);
        // warm sun color rgb(239, 214, 80);
        vec4 specular = specularStrength * spec * mix(texelFetch(Sampler0, topleft, 0), mix(rgb(239, 214, 80), rgb(79, 105, 136), smoothstep(0.8, 0.6, lightlevel.r)) ,0.6);
        blockTex *= (lightMapColor + specular);
        blockTex = blockTex * 1.5 - 0.1;
        fragColor = linear_fog(blockTex, vertexDistance, FogStart, FogEnd, FogColor);
        // fragColor = specular * vertexColor;
    }else{
        vec4 color = texture(Sampler0, texCoord0);
        if (color.a < 0.1) discard;
        color *= vertexColor * ColorModulator;
        color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
        color *= lightMapColor;
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    }
}
