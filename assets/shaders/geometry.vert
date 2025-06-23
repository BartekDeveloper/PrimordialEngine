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

vec2 positions[6] = vec2[](
    /* Screen Quad */
    // T1
    vec2(-1.0, -1.0),
    vec2( 1.0, -1.0),
    vec2(-1.0,  1.0),
    // T2
    vec2(-1.0,  1.0),
    vec2( 1.0, -1.0),
    vec2( 1.0,  1.0)
);

void main() {
    gl_Position = vec4(positions[gl_VertexIndex], 0.0, 1.0);
}
