package vk_destroy 

import "core:log"
import "core:mem"
import "core:c"
import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import rn "base:runtime"

import vk "vendor:vulkan"

import t "../types"

FrameBuffers :: proc(
    data: ^t.VulkanData = nil,
    ctx: rn.Context     = {}
) -> () {
    
    log.debug("\tDestroying Framebuffers")
    for _, &pass in data.passes {
        for &fb in pass.frameBuffers {
            FrameBuffer(
                data,
                &fb
            )
        }
    }
    
    return
}

FrameBuffer :: proc(
    data: ^t.VulkanData = nil,
    fb: ^vk.Framebuffer = nil
) -> () {
    if fb != {} {
        vk.DestroyFramebuffer(
            data.logical.device,
            fb^,
            data.allocations
        )
    }
    assert(fb != nil, "Framebuffer is not destroyed!")
    return
}