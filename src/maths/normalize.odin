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

Length :: linalg.length

@(require_results)
Normalize_i32 :: proc "fastcall" (i: i32) -> (o: i32) {
    o = 1
    return
}

@(require_results)
Normalize_f32 :: proc "fastcall" (i: f32) -> (o: f32) {
    o = 1.0
    return
}

@(require_results)
Normalize_f64 :: proc "fastcall" (i: f64) -> (o: f64) {
    o = 1.0
    return
}

@(require_results)
Normalize_vec2h :: proc "fastcall" (i: Vec2h) -> (o: Vec2h) {
    o = i / Length(i)
    return
}

@(require_results)
Normalize_vec2 :: proc "fastcall" (i: Vec2) -> (o: Vec2) {
    o = i / Length(i)
    return
}

@(require_results)
Normalize_vec2d :: proc "fastcall" (i: Vec2d) -> (o: Vec2d) {
    o = i / Length(i)
    return
}

@(require_results)
Normalize_vec3h :: proc "fastcall" (i: Vec3h) -> (o: Vec3h) {
    o = i / Length(i)
    return
}

@(require_results)
Normalize_vec3 :: proc "fastcall" (i: Vec3) -> (o: Vec3) {
    o = i / Length(i)
    return
}

@(require_results)
Normalize_vec3d :: proc "fastcall" (i: Vec3d) -> (o: Vec3d) {
    o = i / Length(i)
    return
}

@(require_results)
Normalize_vec4h :: proc "fastcall" (i: Vec4h) -> (o: Vec4h) {
    o = i / Length(i)
    return
}

@(require_results)
Normalize_vec4 :: proc "fastcall" (i: Vec4) -> (o: Vec4) {
    o = i / Length(i)
    return
}

@(require_results)
Normalize_vec4d :: proc "fastcall" (i: Vec4d) -> (o: Vec4d) {
    o = i / Length(i)
    return
}

@(require_results)
Normalize_quath :: proc "fastcall" (i: Quath) -> (o: Quath) {
    o = i / Quath(Length(i))
    return
}

@(require_results)
Normalize_quat :: proc "fastcall" (i: Quat) -> (o: Quat) {
    o = i / Quat(Length(i))
    return
}

@(require_results)
Normalize_quatd :: proc "fastcall" (i: Quatd) -> (o: Quatd) {
    o = i / Quatd(Length(i))
    return
}

Normalize :: proc{
    Normalize_i32,
    Normalize_f32,
    Normalize_f64,
    Normalize_vec2h,
    Normalize_vec2,
    Normalize_vec2d,
    Normalize_vec3h,
    Normalize_vec3,
    Normalize_vec3d,
    Normalize_vec4h,
    Normalize_vec4,
    Normalize_vec4d,
    Normalize_quath,
    Normalize_quat,
    Normalize_quatd,
}
