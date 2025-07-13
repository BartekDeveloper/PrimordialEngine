package eentity

import o "../objects"
import s "../../shared"
import em "../../maths"

Entity :: struct {
    id:        u64,
    
    pos:       em.Vec3,
    scale:     em.Vec3,
    rot:       em.Vec3,

    modelName: string,
}

MoveableEntity :: struct {
    Entity,
    
    velocity:     em.Vec3,
    acceleration: em.Vec3,
    friction:     f32,
    mass:         f32,
}





