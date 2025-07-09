
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

    mat4 model;
} ubo;

layout(location = 0) in vec3 inPos;
layout(location = 1) in vec3 inNorm;
layout(location = 2) in vec2 inUv;

layout(location = 0) out vec4 pos;
layout(location = 1) out vec3 norm;
layout(location = 2) out vec2 uv;

void main() {
    vec4 position = ubo.proj * ubo.view * ubo.model * vec4(inPos, 1.0);
    gl_Position = position;

    float u = 0.75;
    float v = 0.5;
    
    uv          = vec2(u, v);
    norm        = vec3(1.0, 1.0, 1.0);
    pos         = position;
    // gl_Position = vec4(inPos, 1.0); 
}
