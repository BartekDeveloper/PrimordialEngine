#version 450

layout(set=0, binding=0) uniform UBO {
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

layout(set=1, binding=0) uniform sampler2D position;
layout(set=1, binding=1) uniform sampler2D albedo;
layout(set=1, binding=2) uniform sampler2D normal;

layout(location = 0) out vec4 outColor;

void main() {
    vec2 uv = {
        gl_FragCoord.x / ubo.winWidth,
        gl_FragCoord.y / ubo.winHeight
    };

    outColor = vec4(
        texture(position, uv).xyz,
        1.0
    ); 
}
