#version 150

uniform sampler2D DiffuseSampler;


in vec2 texCoord;
in vec2 oneTexel;

uniform float Time;

out vec4 fragColor;

#define RED vec4(1,0,0,1)


void main() 
{
    if (texCoord.x < 0.25 && texCoord.y < 0.25 && Time < 0.05){
        fragColor = texture(DiffuseSampler, texCoord) + 0.05;
        if (texture(DiffuseSampler, texCoord).r > 0.3) fragColor = vec4(0);
    }else{
        fragColor = texture(DiffuseSampler, texCoord);
    }

    if (texCoord.x > 0.75 && texCoord.y > 0.75 && texture(DiffuseSampler, vec2(0.8, 0.1)).r != Time){
        fragColor = texture(DiffuseSampler, texCoord) + (1.0 / 255.0);
    }
    if (texCoord.x > 0.75 && texCoord.y < 0.25){
        fragColor = vec4(Time, Time, Time, 1.0);
    }
}
