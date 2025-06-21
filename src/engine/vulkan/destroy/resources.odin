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

Resources :: proc(
    data: ^t.VulkanData = nil
) -> () {

    return
}

GBuffer :: proc "fastcall" (
    data: ^t.VulkanData = nil,
    gBuffer: ^t.GBuffer = nil,
    ctx: rn.Context     = {}
) -> () {

    for i := 0; i < int(data.swapchain.imageCount); i += 1 {
        Image(
            data,
            &gBuffer.images[i],
            ctx
        )

        ImageView(
            data,
            &gBuffer.views[i],
            ctx
        )
        
        Memory(
            data,
            &gBuffer.mems[i],
            ctx
        )
    }

    return
}