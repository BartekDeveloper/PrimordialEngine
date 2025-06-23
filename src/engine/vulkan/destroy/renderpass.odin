package vk_destroy 

import "core:log"
import "core:mem"
import "core:c"

import "core:fmt"
import "core:strings"
import "core:strconv"
import rn "base:runtime"

import vk "vendor:vulkan"

import t "../types"

RenderPasses :: proc(
    data: ^t.VulkanData = nil
) -> () {
    log.debug("\tDestroying Render Passes")
    for k, &renderPass in data.passes {

        log.debugf("\t\t * %s", k)
        RenderPass(
            data,
            &renderPass
        )
    }
    return
}

RenderPass :: proc(
    data: ^t.VulkanData = nil,
    renderPass: ^t.RenderPass = nil
) -> () {
    if renderPass != {} {
        vk.DestroyRenderPass(
            data.logical.device,
            renderPass.renderPass,
            data.allocations
        )
    }
    return
}