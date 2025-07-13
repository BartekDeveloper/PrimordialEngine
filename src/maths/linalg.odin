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
Perspective :: proc "contextless" (
    fovy: f32,
    aspect: f32,
    near: f32,
    far: f32
) -> (o: Mat4 = {}) {
    aspect := aspect
    
    deAspect: f32    = 1.0
    if(aspect < deAspect) {
        aspect   = 1.0
        deAspect = 1.0 / aspect
    }
    
    TanHalfFovy: f32 = math.tan(fovy * 0.5)
    o = {
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0
    }
    
    o[0, 0] = 1.0 / (aspect   * TanHalfFovy)
    o[1, 1] = 1.0 / (deAspect * TanHalfFovy)
    o[2, 2] = far / (near - far)
    o[2, 3] = 1.0
    o[3, 2] = -(far * near) / (far - near)

    return
}

@(require_results)
Perspective_InfDistance :: proc "contextless" (
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
Orthographic :: proc "contextless" (
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
SetViewDir :: proc "contextless" (
    pos: Vec3,
    dir: Vec3,
    up: Vec3
) -> (vo: Mat4 = {}, ivo: Mat4 = {}) {
    
    w: Vec3 = Normalize(dir)
    u: Vec3 = Normalize(Cross(w, up))
    v: Vec3 = Cross(w, u)

    vo = Mat4(1.0)
    vo[0, 0] = u.x;
    vo[1, 0] = u.y;
    vo[2, 0] = u.z;
    vo[0, 1] = v.x;
    vo[1, 1] = v.y;
    vo[2, 1] = v.z;
    vo[0, 2] = w.x;
    vo[1, 2] = w.y;
    vo[2, 2] = w.z;
    vo[3, 0] = -Dot(u, pos);
    vo[3, 1] = -Dot(v, pos);
    vo[3, 2] = -Dot(w, pos);

    ivo = Mat4(1.0);
    ivo[0, 0] = u.x;
    ivo[0, 1] = u.y;
    ivo[0, 2] = u.z;
    ivo[1, 0] = v.x;
    ivo[1, 1] = v.y;
    ivo[1, 2] = v.z;
    ivo[2, 0] = w.x;
    ivo[2, 1] = w.y;
    ivo[2, 2] = w.z;
    ivo[3, 0] = pos.x;
    ivo[3, 1] = pos.y;
    ivo[3, 2] = pos.z;

    return
}

@(require_results)
SetViewTarget :: proc "contextless" (
    pos: Vec3,
    target: Vec3,
    up: Vec3
) -> (vo: Mat4 = {}, ivo: Mat4 = {}) {
    
    targetPos: Vec3 = target - pos
    vo, ivo = SetViewDir(pos, targetPos, up)

    return
}

@(require_results)
SetViewYXZ :: proc "contextless" (
    pos: Vec3,
    rot: Vec3,
) -> (vo: Mat4 = {}, ivo: Mat4 = {}) {

    c3 := Cos(rot.z)
    s3 := Sin(rot.z)
    c2 := Cos(rot.y)
    s2 := Sin(rot.y)
    c1 := Cos(rot.x)
    s1 := Sin(rot.x)

    u: Vec3 = {
        c1 * c3 + s1 * s2 * s3,
        c2 * s3,
        c1 * s2 * s3 - c3 * s1,
    }
    v: Vec3 = {
        c3 * s1 * s2 - c1 * s3,
        c2 * c3,
        c1 * c3 * s2 + s1 * s3,
    }
    w: Vec3 = {
        c2 * s1,
        -s2,
        c1 * c2,
    }

    vo = Mat4(1.0);
    vo[0, 0] = u.x;
    vo[1, 0] = u.y;
    vo[2, 0] = u.z;
    vo[0, 1] = v.x;
    vo[1, 1] = v.y;
    vo[2, 1] = v.z;
    vo[0, 2] = w.x;
    vo[1, 2] = w.y;
    vo[2, 2] = w.z;
    vo[3, 0] = -Dot(u, pos);
    vo[3, 1] = -Dot(v, pos);
    vo[3, 2] = -Dot(w, pos);

    ivo = Mat4(1.0);
    ivo[0, 0] = u.x;
    ivo[0, 1] = u.y;
    ivo[0, 2] = u.z;
    ivo[1, 0] = v.x;
    ivo[1, 1] = v.y;
    ivo[1, 2] = v.z;
    ivo[2, 0] = w.x;
    ivo[2, 1] = w.y;
    ivo[2, 2] = w.z;
    ivo[3, 0] = pos.x;
    ivo[3, 1] = pos.y;
    ivo[3, 2] = pos.z;

    return
}

@(require_results)
LookAt :: proc "contextless" (
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

