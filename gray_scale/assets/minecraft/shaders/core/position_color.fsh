#version 150

in vec4 vertexColor;

uniform vec4 ColorModulator;

out vec4 fragColor;

void main() {
    vec4 color = vertexColor;
    if (color.a == 0.0) {
        discard;
    }
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec4 gray_color = vec4(gray,gray,gray,color.a);
    fragColor = gray_color;
}
