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

layout(location = 0) in vec3 pos;
layout(location = 1) in vec3 norm;
layout(location = 2) in vec2 uv;

layout(location = 0) out vec4 outPosition;
layout(location = 1) out vec4 outAlbedo;
layout(location = 2) out ivec4 outNormal;

void main() {
    outPosition = vec4(pos, 1.0);

    outAlbedo = vec4(1.0, 1.0, 1.0, 1.0);

    ivec3 normalInt = ivec3(round(clamp(norm, -1.0, 1.0) * 127.0));
    outNormal = ivec4(normalInt, 0);
}
