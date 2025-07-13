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
} ubo;

layout(set=1, binding=0) uniform sampler2D position;
layout(set=1, binding=1) uniform sampler2D albedo;
layout(set=1, binding=2) uniform isampler2D normal;

layout(location = 0) out vec4 outColor;

const float BRIGHTNESS = 0.0;
const float CONTRAST   = 1.0; 

void main() {
    vec2 uv = {
        gl_FragCoord.x / ubo.winWidth,
        gl_FragCoord.y / ubo.winHeight
    };

    vec3 albedo   = texture(albedo, uv).xyz;
    vec3 normal   = texture(normal, uv).xyz;
    vec3 posColor = texture(position, uv).xyz;

    
    vec3 color = albedo * posColor + posColor;
    color = (color + BRIGHTNESS) * CONTRAST;
    outColor = vec4(color, 1.0); 
}
