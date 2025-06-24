package engine_shared

import emath "../maths"

RenderData :: #type struct {
    deltaTime:            i64,
    deltaTime_f64:        f64,
    currentFrame:         int,

    MAX_FRAMES_IN_FLIGHT: int,
}

UniformBufferObject :: #type struct {
    // Important
    proj:      emath.Mat4,
    iProj:     emath.Mat4,
    view:      emath.Mat4,
    iView:     emath.Mat4,
    deltaTime: f32,

    // Window
    winWidth:  f32,
    winHeight: f32,

    // Camera
    cameraPos: emath.Vec3,
    cameraUp:  emath.Vec3,
    
    // World
    worldUp:   emath.Vec3,
    worldTime: int,
}
UBO :: #type UniformBufferObject

@(private="file")
VertexData :: #type struct {
    pos:  emath.Vec3,
    norm: emath.Vec3,
    uv0:  emath.Vec2
}
Vertex :: #type VertexData