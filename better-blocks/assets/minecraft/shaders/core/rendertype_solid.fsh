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
flat in vec3 normal;
in vec3 position;
in vec2 faceCoords;
in vec4 lightlevel;

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

        // normal mapping attempt lol
        
    	float EPSILON = 0.001;
    	float dotX = dot(normal, vec3(1, 0, 0));
    	float dotY = dot(normal, vec3(0, 1, 0));
    	float dotZ = dot(normal, vec3(0, 0, 1));
    	vec3 tangent;
    	if (abs(dotX) > 1 - EPSILON) {
    	  tangent = vec3(0, 0, 1) * sign(dotX);
    	} else if (abs(dotY) > 1 - EPSILON) {
    	  tangent = vec3(1, 0, 0) * sign(dotY);
    	} else {
    	  tangent = vec3(1, 0, 0) * sign(dotZ);
    	}
    	vec3 bitangent = cross(tangent, normal);

        // construct tbn
    	vec3 T = normalize(tangent);
        vec3 B = normalize(bitangent);
        vec3 N = normalize(normal);
        mat3 TBN = mat3(T, B, N);
        ivec2 normalMapCoords = ivec2((texCoord0 * atlasSize - faceCoords * cubemapSize * 0.999) + vec2(cubemapSize.y * 2. / 3., 0) + (faceCoords * 102.));
        vec4 normal_sample = texelFetch(Sampler0, normalMapCoords, 0);
        vec3 tex_normal = normal_sample.rgb;
        tex_normal = tex_normal * 2.0 - 1.0;
        // tex_normal = normalize(tex_normal * vec3(3, 3, 1));
        tex_normal = normalize(TBN * tex_normal);
        if (normal_sample.a < 1) tex_normal = normal;

        // cubemap reflection attempt lmao
        ivec2 origin = topleft + (cubemapSize.y / 2);
        ivec2 origin_2 = origin;
        origin_2.x += (cubemapSize.y * 4 / 3);
        vec3 vector = reflect(position, tex_normal);
        vec4 reflection = sampleCubeMap(vector, origin, cubemapSize) * 0.8;
        vec4 reflection_night = sampleCubeMap(vector, origin_2, cubemapSize) * 1.5;
        reflection = mix(reflection, reflection_night, smoothstep(0.9, 0.5, lightlevel.r));
        int index = int(floor(fract(GameTime * 600) * 31));
        // columns, rows
        ivec2 waterCoords = topleft + ivec2(faceCoords * 16);
        vec4 blockTex = texelFetch(Sampler0, waterCoords, 0) * vertexColor * ColorModulator;
        // blockTex = mix(blockTex, reflection, clamp(length(position) / 5 - 0.3, 0.6, 0.6));
        float f0 = 0.195;
        float factor = pow(1 - dot(abs(tex_normal), abs(normalize(position))),1) * texelFetch(Sampler0, topleft + ivec2(faceCoords * 16) + ivec2(16, 0), 0).r;
        blockTex = mix(blockTex, reflection * texelFetch(Sampler0, waterCoords, 0), (factor+0.3 + smoothstep(0.8, 0.6, lightlevel.r)*0.6)*texelFetch(Sampler0, topleft + ivec2(faceCoords * 16) + ivec2(16, 0), 0).r);

        // specular attempt lol
        // float specularStrength = 2;
        float specularStrength = texelFetch(Sampler0, topleft + ivec2(faceCoords * 16) + ivec2(16, 0), 0).r * 2;
        vec3 lightDir = normalize(vec3(0.5,0.5,0.5));
        lightDir = lightDir * TBN;
        lightDir.y = abs(lightDir.y);
        // make specular pixely use floor(position * (sin(GameTime*2000)*8+16))
        vec3 viewDir = normalize(position);
        vec3 reflectDir = reflect(lightDir, tex_normal);

        float spec = pow(max(dot(viewDir, reflectDir), 0.0), 8);
        // warm sun color rgb(239, 214, 80);
        vec4 specular = specularStrength * spec * mix(texelFetch(Sampler0, topleft, 0), mix(rgb(239, 214, 80), rgb(79, 105, 136), smoothstep(0.8, 0.6, lightlevel.r)) ,0.6);
        // compositing specular, fake ambient light
        blockTex *= (mix(vec4(0.8), vertexColor, 0.3) + specular);
        blockTex = blockTex / 1.1 + 0.05;
        fragColor = linear_fog(blockTex, vertexDistance, FogStart, FogEnd, FogColor);

        // shows cubemap reflection
        // fragColor = reflection
    }else{
        // if it's not a special block
        vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
        
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    }
}
