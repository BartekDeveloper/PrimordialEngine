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

Inverse_mat2h :: proc "fastcall" (m: Mat2h) -> (o: Mat2h) {
    o[0, 0] = +m[1, 1]
    o[0, 1] = -m[0, 1]
    o[1, 0] = -m[1, 0]
    o[1, 1] = +m[0, 0]
    return
}

@(require_results)
Inverse_mat2 :: proc "fastcall" (m: Mat2) -> (o: Mat2) {
    o[0, 0] = +m[1, 1]
    o[0, 1] = -m[0, 1]
    o[1, 0] = -m[1, 0]
    o[1, 1] = +m[0, 0]
    return
}

@(require_results)
Inverse_mat2d :: proc "fastcall" (m: Mat2d) -> (o: Mat2d) {
    o[0, 0] = +m[1, 1]
    o[0, 1] = -m[0, 1]
    o[1, 0] = -m[1, 0]
    o[1, 1] = +m[0, 0]
    return
}

@(require_results)
Inverse_mat3h :: proc "fastcall" (m: Mat3h) -> (o: Mat3h) {
    o[0, 0] = +(m[1, 1] * m[2, 2] - m[2, 1] * m[1, 2])
    o[0, 1] = -(m[1, 0] * m[2, 2] - m[2, 0] * m[1, 2])
    o[0, 2] = +(m[1, 0] * m[2, 1] - m[2, 0] * m[1, 1])
    o[1, 0] = -(m[0, 1] * m[2, 2] - m[2, 1] * m[0, 2])
    o[1, 1] = +(m[0, 0] * m[2, 2] - m[2, 0] * m[0, 2])
    o[1, 2] = -(m[0, 0] * m[2, 1] - m[2, 0] * m[0, 1])
    o[2, 0] = +(m[0, 1] * m[1, 2] - m[1, 1] * m[0, 2])
    o[2, 1] = -(m[0, 0] * m[1, 2] - m[1, 0] * m[0, 2])
    o[2, 2] = +(m[0, 0] * m[1, 1] - m[1, 0] * m[0, 1])
    return
}

@(require_results)
Inverse_mat3 :: proc "fastcall" (m: Mat3) -> (o: Mat3) {
    o[0, 0] = +(m[1, 1] * m[2, 2] - m[2, 1] * m[1, 2])
    o[0, 1] = -(m[1, 0] * m[2, 2] - m[2, 0] * m[1, 2])
    o[0, 2] = +(m[1, 0] * m[2, 1] - m[2, 0] * m[1, 1])
    o[1, 0] = -(m[0, 1] * m[2, 2] - m[2, 1] * m[0, 2])
    o[1, 1] = +(m[0, 0] * m[2, 2] - m[2, 0] * m[0, 2])
    o[1, 2] = -(m[0, 0] * m[2, 1] - m[2, 0] * m[0, 1])
    o[2, 0] = +(m[0, 1] * m[1, 2] - m[1, 1] * m[0, 2])
    o[2, 1] = -(m[0, 0] * m[1, 2] - m[1, 0] * m[0, 2])
    o[2, 2] = +(m[0, 0] * m[1, 1] - m[1, 0] * m[0, 1])
    return
}

@(require_results)
Inverse_mat3d :: proc "fastcall" (m: Mat3d) -> (o: Mat3d) {
    o[0, 0] = +(m[1, 1] * m[2, 2] - m[2, 1] * m[1, 2])
    o[0, 1] = -(m[1, 0] * m[2, 2] - m[2, 0] * m[1, 2])
    o[0, 2] = +(m[1, 0] * m[2, 1] - m[2, 0] * m[1, 1])
    o[1, 0] = -(m[0, 1] * m[2, 2] - m[2, 1] * m[0, 2])
    o[1, 1] = +(m[0, 0] * m[2, 2] - m[2, 0] * m[0, 2])
    o[1, 2] = -(m[0, 0] * m[2, 1] - m[2, 0] * m[0, 1])
    o[2, 0] = +(m[0, 1] * m[1, 2] - m[1, 1] * m[0, 2])
    o[2, 1] = -(m[0, 0] * m[1, 2] - m[1, 0] * m[0, 2])
    o[2, 2] = +(m[0, 0] * m[1, 1] - m[1, 0] * m[0, 1])
    return
}

@(require_results)
Inverse_mat4h :: proc "fastcall" (m: Mat4h) -> (o: Mat4h) {
    o[0, 0] = +(m[1, 1] * m[2, 2] - m[2, 1] * m[1, 2])
    o[0, 1] = -(m[1, 0] * m[2, 2] - m[2, 0] * m[1, 2])
    o[0, 2] = +(m[1, 0] * m[2, 1] - m[2, 0] * m[1, 1])
    o[0, 3] = -(m[1, 0] * m[2, 3] - m[2, 0] * m[1, 3])
    o[1, 0] = -(m[0, 1] * m[2, 2] - m[2, 1] * m[0, 2])
    o[1, 1] = +(m[0, 0] * m[2, 2] - m[2, 0] * m[0, 2])
    o[1, 2] = -(m[0, 0] * m[2, 1] - m[2, 0] * m[0, 1])
    o[1, 3] = +(m[0, 0] * m[2, 3] - m[2, 0] * m[0, 3])
    o[2, 0] = +(m[0, 1] * m[1, 2] - m[1, 1] * m[0, 2])
    o[2, 1] = -(m[0, 0] * m[1, 2] - m[1, 0] * m[0, 2])
    o[2, 2] = +(m[0, 0] * m[1, 1] - m[1, 0] * m[0, 1])
    o[2, 3] = -(m[0, 0] * m[1, 3] - m[1, 0] * m[0, 3])
    o[3, 0] = -(m[0, 1] * m[1, 2] - m[1, 1] * m[0, 2])
    o[3, 1] = +(m[0, 0] * m[1, 2] - m[1, 0] * m[0, 2])
    o[3, 2] = -(m[0, 0] * m[1, 1] - m[1, 0] * m[0, 1])        
    o[3, 3] = +(m[0, 0] * m[1, 3] - m[1, 0] * m[0, 3])
    return
}

@(require_results)
Inverse_mat4 :: proc "fastcall" (m: Mat4) -> (o: Mat4) {
    o[0, 0] = +(m[1, 1] * m[2, 2] - m[2, 1] * m[1, 2])
    o[0, 1] = -(m[1, 0] * m[2, 2] - m[2, 0] * m[1, 2])
    o[0, 2] = +(m[1, 0] * m[2, 1] - m[2, 0] * m[1, 1])
    o[0, 3] = -(m[1, 0] * m[2, 3] - m[2, 0] * m[1, 3])
    o[1, 0] = -(m[0, 1] * m[2, 2] - m[2, 1] * m[0, 2])
    o[1, 1] = +(m[0, 0] * m[2, 2] - m[2, 0] * m[0, 2])
    o[1, 2] = -(m[0, 0] * m[2, 1] - m[2, 0] * m[0, 1])
    o[1, 3] = +(m[0, 0] * m[2, 3] - m[2, 0] * m[0, 3])
    o[2, 0] = +(m[0, 1] * m[1, 2] - m[1, 1] * m[0, 2])
    o[2, 1] = -(m[0, 0] * m[1, 2] - m[1, 0] * m[0, 2])
    o[2, 2] = +(m[0, 0] * m[1, 1] - m[1, 0] * m[0, 1])
    o[2, 3] = -(m[0, 0] * m[1, 3] - m[1, 0] * m[0, 3])
    o[3, 0] = -(m[0, 1] * m[1, 2] - m[1, 1] * m[0, 2])
    o[3, 1] = +(m[0, 0] * m[1, 2] - m[1, 0] * m[0, 2])
    o[3, 2] = -(m[0, 0] * m[1, 1] - m[1, 0] * m[0, 1])        
    o[3, 3] = +(m[0, 0] * m[1, 3] - m[1, 0] * m[0, 3])
    return
}

@(require_results)
Inverse_mat4d :: proc "fastcall" (m: Mat4d) -> (o: Mat4d) {
    o[0, 0] = +(m[1, 1] * m[2, 2] - m[2, 1] * m[1, 2])
    o[0, 1] = -(m[1, 0] * m[2, 2] - m[2, 0] * m[1, 2])
    o[0, 2] = +(m[1, 0] * m[2, 1] - m[2, 0] * m[1, 1])
    o[0, 3] = -(m[1, 0] * m[2, 3] - m[2, 0] * m[1, 3])
    o[1, 0] = -(m[0, 1] * m[2, 2] - m[2, 1] * m[0, 2])
    o[1, 1] = +(m[0, 0] * m[2, 2] - m[2, 0] * m[0, 2])
    o[1, 2] = -(m[0, 0] * m[2, 1] - m[2, 0] * m[0, 1])
    o[1, 3] = +(m[0, 0] * m[2, 3] - m[2, 0] * m[0, 3])
    o[2, 0] = +(m[0, 1] * m[1, 2] - m[1, 1] * m[0, 2])
    o[2, 1] = -(m[0, 0] * m[1, 2] - m[1, 0] * m[0, 2])
    o[2, 2] = +(m[0, 0] * m[1, 1] - m[1, 0] * m[0, 1])        
    o[2, 3] = -(m[0, 0] * m[1, 3] - m[1, 0] * m[0, 3])
    o[3, 0] = -(m[0, 1] * m[1, 2] - m[1, 1] * m[0, 2])
    o[3, 1] = +(m[0, 0] * m[1, 2] - m[1, 0] * m[0, 2])
    o[3, 2] = -(m[0, 0] * m[1, 1] - m[1, 0] * m[0, 1])
    o[3, 3] = +(m[0, 0] * m[1, 3] - m[1, 0] * m[0, 3])
    return
}   

@(require_results)
Inverse_quath :: proc "fastcall" (q: Quath) -> (o: Quath) {
    return 1.0 / q
}

@(require_results)
Inverse_quat :: proc "fastcall" (q: Quat) -> (o: Quat) {
    return 1.0 / q
}

@(require_results)
Inverse_quatd :: proc "fastcall" (q: Quatd) -> (o: Quatd) {
    return 1.0 / q
}

Inverse :: proc{
    Inverse_mat2h,
    Inverse_mat2,
    Inverse_mat2d,
    Inverse_mat3h,
    Inverse_mat3,
    Inverse_mat3d,
    Inverse_mat4h,
    Inverse_mat4,
    Inverse_mat4d,
    Inverse_quath,
    Inverse_quat,
    Inverse_quatd,
}
