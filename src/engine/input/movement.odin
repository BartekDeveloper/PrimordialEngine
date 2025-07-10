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
// @important: USED IN ANOTHER FILE
camera: Camera = {
    pos = { 0.0, 0.0, 0.0 },
    rot = { 0.0, 0.0, 0.0 }, // Start rotation at zero for predictable calculations
}

MOVE_SPEED : f32 : 0.25
LOOK_SPEED : f32 : 0.05
ROLL_SPEED : f32 : 0.1

// Model Transformation Constants
SCALE_FACTOR : f32 : 1.1
TRANSLATE_AMOUNT : f32 : 0.5

// @important ModelMatrix: USED IN ANOTHER FILE
modelMatrix: em.Mat4 = linalg.MATRIX4F32_IDENTITY

Move :: proc(
    event:     ^sdl.Event,
) -> () {
    if event.type != .KEY_DOWN {
        return
    }

    oldPos := camera.pos

    // --- C++ Logic: Calculate Direction Vectors based on Camera Rotation ---
    // This is the core of camera-relative movement.
    // It calculates where "forward" is based on the camera's yaw (Y-axis rotation).
    yaw := camera.rot.y
    forwardDir := em.Vec3{math.sin(yaw), 0, math.cos(yaw)}
    rightDir   := em.Vec3{forwardDir.z, 0, -forwardDir.x}
    upDir      := em.Vec3{0, 1, 0} // Using a standard "world up" vector

    // --- Camera Movement (WASD, Space, Shift) ---
    // This now uses the direction vectors for camera-relative movement.
    moveDelta := em.Vec3{0,0,0}
    moved := false
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

    // Apply movement if any move key was pressed
    // The `linalg.dot > math.F32_EPSILON` check prevents normalizing a zero vector.
    if linalg.dot(moveDelta, moveDelta) > math.F32_EPSILON {
        camera.pos += linalg.normalize(moveDelta) * MOVE_SPEED
    }
    
    // --- Camera Rotation (Arrow Keys) ---
    // This logic is taken directly from the C++ file.
    rotDelta := em.Vec3{0,0,0}
    if event.key.scancode == .RIGHT { rotDelta.y += 1.0 }
    if event.key.scancode == .LEFT  { rotDelta.y -= 1.0 }
    if event.key.scancode == .UP    { rotDelta.x += 1.0 }
    if event.key.scancode == .DOWN  { rotDelta.x -= 1.0 }

    if linalg.dot(rotDelta, rotDelta) > math.F32_EPSILON {
        camera.rot += linalg.normalize(rotDelta) * LOOK_SPEED

        // limit pitch values between about +/- 85ish deg
        camera.rot.x = math.clamp(camera.rot.x, -1.5, 1.5)
        // wrap yaw
        camera.rot.y = math.mod(camera.rot.y, 2 * math.PI)
        
        fmt.eprintfln("New Camera Rot: %v", camera.rot)
    }

    // --- Camera Rotation (Roll, Q/E) ---
    // Replaced math.sin with simple addition for continuous rolling.
    if event.key.scancode == .Q {
        camera.rot.z += ROLL_SPEED
        fmt.eprintfln("New Camera Rot: %v", camera.rot)
    }
    if event.key.scancode == .E {
        camera.rot.z -= ROLL_SPEED
        fmt.eprintfln("New Camera Rot: %v", camera.rot)
    }
    
    // --- Model Translation (IJKL/UO) ---
    // This logic is unchanged from your original file.
    if event.key.scancode == .J { modelMatrix[3, 2] += TRANSLATE_AMOUNT }
    if event.key.scancode == .L { modelMatrix[3, 2] -= TRANSLATE_AMOUNT }
    if event.key.scancode == .I { modelMatrix[3, 1] += TRANSLATE_AMOUNT }
    if event.key.scancode == .K { modelMatrix[3, 1] -= TRANSLATE_AMOUNT }
    if event.key.scancode == .U { modelMatrix[3, 0] += TRANSLATE_AMOUNT }
    if event.key.scancode == .O { modelMatrix[3, 0] -= TRANSLATE_AMOUNT }

    // --- Model Scaling (N/M) ---
    // This logic is unchanged from your original file.
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


    // --- Final Logging ---
    if oldPos != camera.pos {
        fmt.eprintfln("New Camera Pos: %v", camera.pos)
    }
    
    return
}