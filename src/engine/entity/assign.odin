package eentity

import o "../objects"
import s "../../shared"
import em "../../maths"

New :: proc(entity: ^Entity) -> () {
    NewWithId(entity, RandomizeId())
    return
}

NewWithId :: proc(entity: ^Entity, id: u64) -> () {
    entity.id = id
    entity.pos   = { 0.0, 0.0, 0.0 }
    entity.rot   = { 0.0, 0.0, 0.0 }
    entity.scale = { 1.0, 1.0, 1.0 }
    return
}

NewMoveable :: proc(entity: ^MoveableEntity) -> () {
    New(auto_cast entity)
    return
}

NewMoveableWithId :: proc(entity: ^MoveableEntity, id: u64) -> () {
    NewWithId(auto_cast entity, id)
    return
}

SetModelName :: proc(entity: ^Entity, name: string) -> () {
    entity.modelName = name
    return
}

SetModelNameWithId :: proc(entity: ^Entity, id: u64, modelName: string) -> () {
    entity.id = id
    entity.modelName = modelName
    return
}

SetPosition :: proc(entity: ^Entity, position: em.Vec3) -> () {
    entity.pos = position
    return
}

SetVelocity :: proc(entity: ^MoveableEntity, velocity: em.Vec3) -> () {
    entity.velocity = velocity
    return
}

SetAcceleration :: proc(entity: ^MoveableEntity, acceleration: em.Vec3) -> () {
    entity.acceleration = acceleration
    return
}

SetFriction :: proc(entity: ^MoveableEntity, friction: f32) -> () {
    entity.friction = friction
    return
}

SetMass :: proc(entity: ^MoveableEntity, mass: f32) -> () {
    entity.mass = mass
    return
}

SetRotation :: proc(entity: ^Entity, rotation: em.Vec3) -> () {
    entity.rot = rotation
    return
}

SetScale :: proc(entity: ^Entity, scale: em.Vec3) -> () {
    entity.scale = scale
    return
}

MoveX :: proc(entity: ^Entity, amount: f32) -> () {
    entity.pos.x += amount
    return
}

MoveY :: proc(entity: ^Entity, amount: f32) -> () {
    entity.pos.y += amount
    return
}

MoveZ :: proc(entity: ^Entity, amount: f32) -> () {
    entity.pos.z += amount
    return
}

RotateX :: proc(entity: ^Entity, amount: f32) -> () {
    entity.rot.x += amount
    return
}

RotateY :: proc(entity: ^Entity, amount: f32) -> () {
    entity.rot.y += amount
    return
}

RotateZ :: proc(entity: ^Entity, amount: f32) -> () {
    entity.rot.z += amount
    return
}

ScaleX :: proc(entity: ^Entity, amount: f32) -> () {
    entity.scale.x += amount
    return
}

ScaleY :: proc(entity: ^Entity, amount: f32) -> () {
    entity.scale.y += amount
    return
}

ScaleZ :: proc(entity: ^Entity, amount: f32) -> () {
    entity.scale.z += amount
    return
}   
