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

layout(location = 0) in vec4 pos;
layout(location = 1) in vec3 norm;
layout(location = 2) in vec2 uv;

layout(location = 0) out vec4  Position;
layout(location = 1) out vec4  Albedo;
layout(location = 2) out ivec4 Normal;

void main() {
    Position = pos;
    Albedo   = vec4(0.5, 0.5, 0.5, 1.0);
    Normal   = ivec4(0.5, 0.5, 0.5, 1.0);
}
