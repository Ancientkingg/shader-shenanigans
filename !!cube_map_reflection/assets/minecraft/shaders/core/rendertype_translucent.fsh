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
in vec3 flat_Normal;
in vec4 lightlevel;
in float skylevel;

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
        ivec2 coords = newOrigin - ivec2(dir.zx * (cubemapSize.y / 6)) * int(sign(dir.y));
        return texelFetch(Sampler0, coords, 0);
    }else if (maxDir == absDir.z){
        // what to do when it hit the z-sides
        newOrigin.x -= int((cubemapSize.y / 3) * sign(dir.z));
        ivec2 coords = newOrigin + ivec2(dir.y * (cubemapSize.y / 6) * sign(dir.z), dir.x * (cubemapSize.y / 6) * -1);
        return texelFetch(Sampler0, coords, 0);
    }
}




void main() {
    vec2 atlasSize = textureSize(Sampler0, 0);
    const ivec2 cubemapSize = ivec2(816,306);
    ivec2 topleft = ivec2(texCoord0 * atlasSize - faceCoords * cubemapSize * 0.998);
    if (texture(Sampler0, (vec2(texCoord0 * atlasSize - faceCoords * cubemapSize * 0.998) + vec2(0, cubemapSize.y - 0.5)) / atlasSize).rgb == vec3(1,0,0) && dot(position, flat_Normal) > -100 && dot(position, flat_Normal) < 0){
        ivec2 origin = topleft + (cubemapSize.y / 2);
        ivec2 origin_2 = origin;
        origin_2.x += (cubemapSize.y * 4 / 3);
        vec3 vector = reflect(position, normal);
        vec4 reflection = sampleCubeMap(vector, origin, cubemapSize);
        vec4 reflection_night = sampleCubeMap(vector, origin_2, cubemapSize) * 1.5;
        reflection = mix(reflection, reflection_night, smoothstep(0.8, 0.6, lightlevel.r));
        int index = int(floor(fract(GameTime * 600) * 31));
        // columns, rows
        ivec2 offset = ivec2(index / 6, index % 6);
        ivec2 waterCoords = topleft + ivec2((faceCoords + offset) * 16);
        vec4 waterTex = texelFetch(Sampler0, waterCoords, 0) * vertexColor * ColorModulator;
        // waterTex = mix(waterTex, reflection, clamp(length(position) / 5 - 0.3, 0.6, 0.6));
        float theta = 1 - dot(normal, normalize(position));
        theta = pow(theta, 3);
        if (int(skylevel) > 230) waterTex = mix(waterTex, reflection, clamp(theta, 0.45, 1));
        else waterTex = mix(waterTex, reflection, smoothstep(220,240,skylevel));
        // reflection.a = mix(180./255.,0.9,clamp(theta, 0.45, 1));
        fragColor = linear_fog(waterTex, vertexDistance, FogStart, FogEnd, FogColor);
    }else if (dot(position, flat_Normal) > 0){
        fragColor = texelFetch(Sampler0, ivec2(topleft.x, topleft.y), 0);
        vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
        fragColor = vec4(topleft, 0, 1);
        fragColor = vec4(vertexColor.rgb, clamp(180. * length(position) / 5 - 10, 0, 200) /255.);
    }else{
        vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    }
}
