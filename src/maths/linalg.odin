package engine_math

import "core:math"
import "core:math/big"
import "core:math/bits"
import "core:math/cmplx"
import "core:math/ease"
import "core:math/fixed"
import "core:math/linalg"
import "core:math/linalg/glsl"
import "core:math/linalg/hlsl"
import "core:math/noise"
import "core:math/rand"

@(require_results)
Perspective :: proc "fastcall" (
    fovy: f32,
    aspect: f32,
    near: f32,
    far: f32
) -> (o: Mat4 = {}) {
    TanHalfFovy := Tan(0.5 * fovy)

    o[0, 0] = 1.0 / (aspect * TanHalfFovy)
    o[1, 1] = 1.0 / (TanHalfFovy)
    o[2, 2] = -(far + near) / (far - near)
    o[2, 3] = (-1.0)
    o[3, 2] = (-2.0 * far * near) / (far - near)

    return
}

@(require_results)
Perspective_InfDistance :: proc "fastcall" (
    fovy: f32,
    aspect: f32,
    near: f32
) -> (o: Mat4 = {}) {
    TanHalfFovy := Tan(0.5 * fovy)

    o[0, 0] = 1.0 / (aspect * TanHalfFovy)
    o[1, 1] = 1.0 / (TanHalfFovy)
    o[2, 2] = (-1.0)
    o[2, 3] = (-1.0)
    o[3, 2] = (-2.0 * near)

    return
}

@(require_results)
Orthographic :: proc "fastcall" (
    top: f32,
    right: f32,
    bottom: f32,
    left: f32,

    near: f32,
    far: f32
) -> (o: Mat4 = {}) {
    
    o[0, 0] =  2.0 / (right - left)
    o[1, 1] =  2.0 / (top - bottom)
    o[2, 2] = -2.0 / (far - near)
    o[0, 3] = -(right + left) / (right - left)
    o[1, 3] = -(top + bottom) / (top - bottom)
    o[2, 3] = -(far + near) / (far - near)
    o[3, 3] = 1.0

    return  
}

@(require_results)
LookAt :: proc "fastcall" (
    eye: Vec3,
    center: Vec3,
    up: Vec3
) -> (o: Mat4 = {}) {
    f := Normalize(center - eye)
    s := Normalize(Cross(f, up))
    u := Cross(s, f)
    
    fe := Dot(f, eye)

    o[0] = { s.x, u.x, -f.x, 0.0 }
    o[1] = { s.y, u.y, -f.y, 0.0 }
    o[2] = { s.z, u.z, -f.z, 0.0 }
    o[3] = { fe * -1.0, 0.0, 0.0, 1.0 }
    o[3] = { fe * -1.0, 0.0, 0.0, 1.0 }

    return
}

