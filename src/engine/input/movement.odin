package einput

import "core:math"
import "core:math/linalg"
import "core:log"
import "core:c"
import "core:fmt"
import rn "base:runtime"

import em "../../maths"

import sdl "vendor:sdl3"

Camera :: #type struct {
    pos:      em.Vec3,
    rot:      em.Vec3,
}
camera: Camera = {
    pos = { 0.0, 0.0, 0.0 },
    rot = { 0.0, 0.0, 0.0 },
}

MOVE_SPEED : f32 : 1.0
LOOK_SPEED : f32 : 0.05
ROLL_SPEED : f32 : 0.1

SCALE_FACTOR : f32 : 1.1
TRANSLATE_AMOUNT : f32 : 0.5

modelMatrix: em.Mat4 = linalg.MATRIX4F32_IDENTITY

Move :: proc(
    event:     ^sdl.Event,
) -> () {
    if event.type != .KEY_DOWN do return
    
    oldPos := camera.pos
    yaw := camera.rot.y

    forwardDir := em.Vec3{math.sin(yaw), 0, math.cos(yaw)}
    rightDir   := em.Vec3{forwardDir.z, 0, -forwardDir.x}
    upDir      := em.Vec3{0, 1, 0} 
    moveDelta  := em.Vec3{0,0,0}

    moved     := false
    if event.key.scancode == .W {
        moveDelta += forwardDir
        moved = true
    }
    if event.key.scancode == .S {
        moveDelta -= forwardDir
        moved = true
    }
    if event.key.scancode == .D {
        moveDelta += rightDir
        moved = true
    }
    if event.key.scancode == .A {
        moveDelta -= rightDir
        moved = true
    }
    if event.key.scancode == .SPACE || event.key.scancode == .KP_SPACE {
        moveDelta += upDir
        moved = true
    }
    if event.key.scancode == .LSHIFT || event.key.scancode == .RSHIFT {
        moveDelta -= upDir
        moved = true
    }

    if linalg.dot(moveDelta, moveDelta) > math.F32_EPSILON {
        camera.pos += linalg.normalize(moveDelta) * MOVE_SPEED
    }
    
    rotDelta := em.Vec3{0,0,0}
    if event.key.scancode == .RIGHT { rotDelta.y += 1.0 }
    if event.key.scancode == .LEFT  { rotDelta.y -= 1.0 }
    if event.key.scancode == .UP    { rotDelta.x += 1.0 }
    if event.key.scancode == .DOWN  { rotDelta.x -= 1.0 }

    if linalg.dot(rotDelta, rotDelta) > math.F32_EPSILON {
        camera.rot += linalg.normalize(rotDelta) * LOOK_SPEED

        camera.rot.x = math.clamp(camera.rot.x, -1.5, 1.5)
        camera.rot.y = math.mod(camera.rot.y, 2 * math.PI)
        
        fmt.eprintfln("New Camera Rot: %v", camera.rot)
    }

    if event.key.scancode == .Q {
        camera.rot.z += ROLL_SPEED
        fmt.eprintfln("New Camera Rot: %v", camera.rot)
    }
    if event.key.scancode == .E {
        camera.rot.z -= ROLL_SPEED
        fmt.eprintfln("New Camera Rot: %v", camera.rot)
    }
    
    if event.key.scancode == .J { modelMatrix[3, 2] += TRANSLATE_AMOUNT }
    if event.key.scancode == .L { modelMatrix[3, 2] -= TRANSLATE_AMOUNT }
    if event.key.scancode == .I { modelMatrix[3, 1] += TRANSLATE_AMOUNT }
    if event.key.scancode == .K { modelMatrix[3, 1] -= TRANSLATE_AMOUNT }
    if event.key.scancode == .U { modelMatrix[3, 0] += TRANSLATE_AMOUNT }
    if event.key.scancode == .O { modelMatrix[3, 0] -= TRANSLATE_AMOUNT }

    if event.key.scancode == .N {
        modelMatrix[0, 0] *= SCALE_FACTOR
        modelMatrix[1, 1] *= SCALE_FACTOR
        modelMatrix[2, 2] *= SCALE_FACTOR
    }
    if event.key.scancode == .M {
        modelMatrix[0, 0] /= SCALE_FACTOR
        modelMatrix[1, 1] /= SCALE_FACTOR
        modelMatrix[2, 2] /= SCALE_FACTOR
    }


    if oldPos != camera.pos {
        fmt.eprintfln("New Camera Pos: %v", camera.pos)
    }
    
    return
}