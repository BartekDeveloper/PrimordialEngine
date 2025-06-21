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

    log.debug("\tDestroying Resources")
    log.debug("\t\tGBuffers")
    for k, &gBuffer in data.gBuffers {
        
        log.debugf("\t\t\t * %s", k)
        GBuffer(
            data,
            &gBuffer
        )
    }
    return
}

GBuffer :: proc(
    data: ^t.VulkanData = nil,
    gBuffer: ^t.GBuffer = nil
) -> () {

    for i := 0; i < int(data.swapchain.imageCount); i += 1 {
        Image(
            data,
            &gBuffer.images[i],
            context
        )

        ImageView(
            data,
            &gBuffer.views[i],
            context
        )
        
        Memory(
            data,
            &gBuffer.mems[i],
            context
        )
    }

    return
}