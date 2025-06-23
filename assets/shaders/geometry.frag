#version 450

layout(binding=0) uniform UBO {
    mat4 proj;
    mat4 iProj;
    mat4 view;
    mat4 iView;
    float deltaTime;

    float winWidth;
    float winHeight;

    vec3 cameraPos;
    vec3 cameraUp;
    
    vec3 worldUp;
    int worldTime;
} ubo;

layout(location = 0) out vec4 outColor;

void main() {
    float r = gl_FragCoord.x / 1280.0;
    float g = gl_FragCoord.y / 720.0;
    float b = 0;

    outColor = vec4(r, g, b, 1.0);

}
