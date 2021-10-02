#version 150

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform vec2 ScreenSize;

in vec2 texCoord0;

out vec4 fragColor;


vec4 BlurColor (vec2 Coord, sampler2D Tex, float MipBias)
{
	vec2 TexelSize = MipBias/ScreenSize;
    
    vec4  Color = texture(Tex, Coord, MipBias);
    Color += texture(Tex, Coord + vec2(TexelSize.x,0.0), MipBias);    	
    Color += texture(Tex, Coord + vec2(-TexelSize.x,0.0), MipBias);    	
    Color += texture(Tex, Coord + vec2(0.0,TexelSize.y), MipBias);    	
    Color += texture(Tex, Coord + vec2(0.0,-TexelSize.y), MipBias);    	
    Color += texture(Tex, Coord + vec2(TexelSize.x,TexelSize.y), MipBias);    	
    Color += texture(Tex, Coord + vec2(-TexelSize.x,TexelSize.y), MipBias);    	
    Color += texture(Tex, Coord + vec2(TexelSize.x,-TexelSize.y), MipBias);    	
    Color += texture(Tex, Coord + vec2(-TexelSize.x,-TexelSize.y), MipBias);    

    return Color/9.0;
}

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a == 0.0) discard;
    if (texture(Sampler0, vec2(0)) == vec4(1,0,0,1)){
        float Threshold = 0.0;
        float Intensity = 1.0;
        float BlurSize = 3.0;
        vec4 Color = texture(Sampler0, texCoord0);

        vec4 Highlight = clamp(BlurColor(texCoord0, Sampler0, BlurSize)-Threshold,0.0,1.0)*1.0/(1.0-Threshold);

        color = 1.0-(1.0-Color)*(1.0-Highlight*Intensity) * 1.1;
        vec4 overlay = (1 - distance(texCoord0, vec2(0.5)) * 2) * (vec4(243., 229., 188., 255.) / 255.) * 1.5 - 0.5;
        fragColor = mix(color, overlay, 0.65);
    }else{
        fragColor = color * ColorModulator;
    }
}
