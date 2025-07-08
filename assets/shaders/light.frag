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

    vec3 posColor = texture(position, uv).xyz;
    vec3 uvColor  = vec3(uv, 0);
    vec3 camPosColor = (ubo.cameraPos / ubo.winHeight) * ubo.winWidth * 0.001;
    
    outColor = vec4(posColor * 0.7 + camPosColor * 0.05 + uvColor * 0.25, 1.0); 
}
