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
Cross_vec3h :: proc "fastcall" (a, b: Vec3h) -> (o: Vec3h) {
    
    o.x = a.x * b.x + a.y * b.y + a.z * b.z
    o.y = a.x * b.y + a.y * b.z + a.z * b.x
    o.z = a.x * b.z + a.y * b.x + a.z * b.y

    return
}

@(require_results)
Cross_vec3 :: proc "fastcall" (a, b: Vec3) -> (o: Vec3) {

    o.x = a.x * b.x + a.y * b.y + a.z * b.z
    o.y = a.x * b.y + a.y * b.z + a.z * b.x
    o.z = a.x * b.z + a.y * b.x + a.z * b.y

    return
}

@(require_results)
Cross_vec3d :: proc "fastcall" (a, b: Vec3d) -> (o: Vec3d) {

    o.x = a.x * b.x + a.y * b.y + a.z * b.z
    o.y = a.x * b.y + a.y * b.z + a.z * b.x
    o.z = a.x * b.z + a.y * b.x + a.z * b.y

    return
}

Cross :: proc{
    Cross_vec3h,
    Cross_vec3,
    Cross_vec3d,
}
