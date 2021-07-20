#version 150

#moj_import <light.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
flat out vec3 normal;
out vec3 distance;
out vec2 faceCoords;
out vec3 position;

#define PI 3.14159
#define FREQUENCY 400
#define FAR 70

vec2 generateFaceCoords(){
    if (gl_VertexID % 4 == 0) return vec2(0.0,0.0);
    else if (gl_VertexID % 4 == 1) return vec2(0.0,1.0);
    else if (gl_VertexID % 4 == 2) return vec2(1.0,1.0);
    else if (gl_VertexID % 4 == 3) return vec2(1.0,0.0);
}

float rand(vec2 c){
	return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float freq ){
	float unit = FREQUENCY/freq;
	vec2 ij = floor(p/unit);
	vec2 xy = mod(p,unit)/unit;
	//xy = 3.*xy*xy-2.*xy*xy*xy;
	xy = .5*(1.-cos(PI*xy));
	float a = rand((ij+vec2(0.,0.)));
	float b = rand((ij+vec2(1.,0.)));
	float c = rand((ij+vec2(0.,1.)));
	float d = rand((ij+vec2(1.,1.)));
	float x1 = mix(a, b, xy.x);
	float x2 = mix(c, d, xy.x);
	return mix(x1, x2, xy.y);
}

float pNoise(vec2 p, int res){
	float persistance = .5;
	float n = 0.;
	float normK = 0.;
	float f = 4.;
	float amp = 1.;
	int iCount = 0;
	for (int i = 0; i<50; i++){
		n+=amp*noise(p, f);
		f*=2.;
		normK+=amp;
		amp*=persistance;
		if (iCount == res) break;
		iCount++;
	}
	float nf = n/normK;
	return nf*nf*nf*nf;
}

float fbm(vec2 pos, int octaves, float gain) {
  float value = 0;
  float totalWeight = 0;
  float weight = 1;
  float frequency = 1;
  for (int i = 0; i < octaves; i++) {
    value += pNoise(pos * frequency,1) * weight;
    totalWeight += weight;
    frequency *= 2;
    weight *= gain;
  }
  return value / totalWeight;
}

void main() {
    vec3 pos = Position + ChunkOffset;
    float animation = GameTime * 1000;
    // float noise = pNoise(pos.xz, 1) * (max(length(pos) - FAR,0) * 0.2);
    float noise = fbm((vec2(pos.x+animation,pos.z)) / 8., 7,1) * (max(length(pos) - FAR,0) * 0.75);
    pos.y += noise;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
    distance = Position + ChunkOffset;
    position = Position;
    vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = Normal;
    faceCoords = generateFaceCoords();
}
