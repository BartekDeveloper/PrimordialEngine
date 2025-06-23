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
Dot_i32 :: proc "fastcall" (a, b: i32) -> (o: i32) {
    o = a * b
    return
}

@(require_results)
Dot_f32 :: proc "fastcall" (a, b: f32) -> (o: f32) {
    o = a * b
    return
}

@(require_results)
Dot_f64 :: proc "fastcall" (a, b: f64) -> (o: f64) {
    o = a * b
    return
}

@(require_results)
Dot_vec2h :: proc "fastcall" (a, b: Vec2h) -> (o: f16) {
    o = a.x * b.x + a.y * b.y
    return
}

@(require_results)
Dot_vec2 :: proc "fastcall" (a, b: Vec2) -> (o: f32) {
    o = a.x * b.x + a.y * b.y
    return
}

@(require_results)
Dot_vec2d :: proc "fastcall" (a, b: Vec2d) -> (o: f64) {
    o = a.x * b.x + a.y * b.y
    return
}

@(require_results)
Dot_vec3h :: proc "fastcall" (a, b: Vec3h) -> (o: f16) {
    o = a.x * b.x + a.y * b.y + a.z * b.z
    return
}

@(require_results)
Dot_vec3 :: proc "fastcall" (a, b: Vec3) -> (o: f32) {
    o = a.x * b.x + a.y * b.y + a.z * b.z
    return
}

@(require_results)
Dot_vec3d :: proc "fastcall" (a, b: Vec3d) -> (o: f64) {
    o = a.x * b.x + a.y * b.y + a.z * b.z
    return
}

@(require_results)
Dot_vec4h :: proc "fastcall" (a, b: Vec4h) -> (o: f16) {
    o = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
    return
}

@(require_results)
Dot_vec4 :: proc "fastcall" (a, b: Vec4) -> (o: f32) {
    o = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
    return
}

@(require_results)
Dot_vec4d :: proc "fastcall" (a, b: Vec4d) -> (o: f64) {
    o = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
    return
}

@(require_results)
Dot_quath :: proc "fastcall" (a, b: Quath) -> (o: f16) {
    o = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
    return
}

@(require_results)
Dot_quat :: proc "fastcall" (a, b: Quat) -> (o: f32) {
    o = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
    return
}

@(require_results)
Dot_quatd :: proc "fastcall" (a, b: Quatd) -> (o: f64) {
    o = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
    return
}

Dot :: proc{
    Dot_i32,
    Dot_f32,
    Dot_f64,
    Dot_vec2h,
    Dot_vec2,
    Dot_vec2d,
    Dot_vec3h,
    Dot_vec3,
    Dot_vec3d,
    Dot_vec4h,
    Dot_vec4,
    Dot_vec4d,
    Dot_quath,
    Dot_quat,
    Dot_quatd,
}
