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

modelMatrix: em.Mat4 = {
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
}

Move :: proc(
    event:     ^sdl.Event
) -> () {
    oldPos := camera.pos

    if event.type == .KEY_DOWN {
        if event.key.scancode == .W {
            camera.pos.z += 0.1
        } else if event.key.scancode == .S {
            camera.pos.z -= 0.1
        } else if event.key.scancode == .A {
            camera.pos.x -= 0.1
        } else if event.key.scancode == .D {
            camera.pos.x += 0.1
        } else if event.key.scancode == .SPACE || event.key.scancode == .KP_SPACE {
            camera.pos.y += 0.1
        } else if event.key.scancode == .LSHIFT || event.key.scancode == .RSHIFT {
            camera.pos.y -= 0.1
        } else if event.key.scancode == .Q {
            camera.rot.z += 0.1
            fmt.eprintfln("New Camera Rot: %v", camera.rot)
        } else if event.key.scancode == .E {
            camera.rot.z -= 0.1
            fmt.eprintfln("New Camera Rot: %v", camera.rot)
        }

        if event.key.scancode == .J {
            modelMatrix[3, 2] += 0.1
        } else if event.key.scancode == .L {
            modelMatrix[3, 2] -= 0.1
        } else if event.key.scancode == .I {
            modelMatrix[3, 1] += 0.1
        } else if event.key.scancode == .K {
            modelMatrix[3, 1] -= 0.1
        } else if event.key.scancode == .U {
            modelMatrix[3, 0] += 0.1
        } else if event.key.scancode == .O {
            modelMatrix[3, 0] -= 0.1
        }

        if event.key.scancode == .N {
            modelMatrix[0, 0] += 0.5
            modelMatrix[1, 1] += 0.5
            modelMatrix[2, 2] += 0.5
        } else if event.key.scancode == .M {
            modelMatrix[0, 0] -= 0.5
            modelMatrix[1, 1] -= 0.5
            modelMatrix[2, 2] -= 0.5
        }
    }

    if oldPos != camera.pos {
        fmt.eprintfln("New Camera Pos: %v", camera.pos)
        fmt.eprintfln("Change in Camera Pos: %v", camera.pos - oldPos)
    }

    @static rotating: bool = false
    if rotating do fmt.eprintln("Rotating")

    if event.type == .MOUSE_BUTTON_DOWN {
        rotating = true
    } else if event.type == .MOUSE_BUTTON_UP {
        rotating = false
    }

    if rotating && event.type == .MOUSE_MOTION {
        camera.rot.x = math.sin(camera.rot.x + (event.motion.xrel * 0.1))
        camera.rot.y = math.sin(camera.rot.y + (event.motion.yrel * 0.1))

        fmt.eprintfln("New Camera Rot: %v", camera.rot)
        
        _ = fmt.eprintfln("Facing up")      if camera.rot.y > 0.0 else fmt.eprintfln("Facing down")
        _ = fmt.eprintfln("Facing left")    if camera.rot.x > 0.0 else fmt.eprintfln("Facing right")
        _ = fmt.eprintfln("Facing forward") if camera.rot.z > 0.0 else fmt.eprintfln("Facing backward")
    }
    
    // Tell me where am i facing (in contrast to default position of { 0, 0, 0} and rotation of {1, 0, 0}).
    // - forward, backward, lefty, righty
    // MAKE FUCKING CODE
    
    return
}