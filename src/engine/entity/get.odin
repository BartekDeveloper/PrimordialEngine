package eentity

import "core:math"
import "core:math/linalg"
import "core:math/cmplx"
import em "../../maths"

GetModelMatrix :: proc(entity: ^Entity) -> (o: em.Mat4 = {}) {
    using entity

    translate_mat := linalg.matrix4_translate_f32(pos)
    scale_mat     := linalg.matrix4_scale_f32(scale)

    rot_x_mat := linalg.matrix4_rotate_f32(rot.x, { 1, 0, 0 })
    rot_y_mat := linalg.matrix4_rotate_f32(rot.y, { 0, 1, 0 })
    rot_z_mat := linalg.matrix4_rotate_f32(rot.z, { 0, 0, 1 })
    rot_mat   := rot_z_mat * rot_y_mat * rot_x_mat

    o = translate_mat * rot_mat * scale_mat

    return
}

GetScale :: proc(entity: ^Entity) -> (o: em.Vec3) {
    using entity
    o = scale
    return
}

GetPosition :: proc(entity: ^Entity) -> (o: em.Vec3) {
    using entity
    o = pos
    return
}

GetRotation :: proc(entity: ^Entity) -> (o: em.Vec3) {
    using entity
    o = rot
    return
}

GetVelocity :: proc(entity: ^MoveableEntity) -> (o: em.Vec3) {
    using entity
    o = velocity
    return
}

GetAcceleration :: proc(entity: ^MoveableEntity) -> (o: em.Vec3) {
    using entity
    o = acceleration
    return
}

GetFriction :: proc(entity: ^MoveableEntity) -> (o: f32) {
    using entity
    o = friction
    return
}

GetMass :: proc(entity: ^MoveableEntity) -> (o: f32) {
    using entity
    o = mass
    return
}