package vk_destroy 

import "core:log"
import "core:mem"
import "core:c"
import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

import vk "vendor:vulkan"

import t "../types"

RenderPasses :: proc(
    data: ^t.VulkanData = nil
) -> () {

    for _, &renderPass in data.passes {
        RenderPass(
            data,
            &renderPass,
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