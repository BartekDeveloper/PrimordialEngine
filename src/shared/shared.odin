package engine_shared

import emath "../maths"

PushData :: #type struct {
    size:  u32,
    data: rawptr
}

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
    
    // Temporary
    model: emath.Mat4,
}
UBO :: #type UniformBufferObject

// @(private="file")
VertexData :: #type struct {
    boneId:     emath.iVec4,
    boneWeight: emath.Vec4,
    pos:        emath.Vec3,
    norm:       emath.Vec3,
    tan:        emath.Vec3,
//  btan:       emath.Vec3,
    color:      emath.Vec3,
    uv0:        emath.Vec2,
}
Vertex :: #type VertexData