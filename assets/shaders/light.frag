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

const float BRIGHTNESS = 0.1;
const float CONTRAST   = 2.0;

void main() {
    vec2 uv = {
        gl_FragCoord.x / ubo.winWidth,
        gl_FragCoord.y / ubo.winHeight
    };

    vec3 posColor = texture(position, uv).xyz;
    vec3 uvColor  = vec3(uv, 0);
    vec3 camPosColor = (ubo.cameraPos / ubo.winHeight) * ubo.winWidth * 0.001;
    
    float brightness = BRIGHTNESS;
    if(ubo.cameraPos.x >= 0.0f && ubo.cameraPos.x <= 0.5f) {
        brightness *= 0.5;
    } else {
        brightness *= 2.0;
    }

    if (ubo.cameraPos.x >= 0.5f && ubo.cameraPos.x <= 1.0f) {
        brightness *= 0.5;
    } else {
        brightness *= 2.0;
    }

    posColor = (posColor + brightness) * CONTRAST;
    outColor = vec4(posColor * 5.0, 1.0); 
}
