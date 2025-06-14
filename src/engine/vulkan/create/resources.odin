package vk_create

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import "../choose"
import t "../types"
import win "../../window"

Resources :: proc(data: ^t.VulkanData) -> () {
    using data;
    good: bool = true

    swapchain.formats.color = swapchain.formats.surface.format
    screen := swapchain.extent
    
    lightPass := passes["light"]
    
    log.debug("Creating Resources")
    log.debug("\t Color Buffer")
    {
        colorBuffer: t.GBuffer = {}
        good = GBuffer(
            data,
            &colorBuffer,
            swapchain.formats.color,
            screen.width, screen.height,
            .OPTIMAL,
            { .COLOR_ATTACHMENT },
            { .DEVICE_LOCAL },
            { .COLOR }
        )
        if !good {
            log.panic("Failed to create Color Buffer!")
        }
        gBuffers["light.color"] = colorBuffer
    }

    log.debug("\t Depth Buffer")
    {
        depthBuffer: t.GBuffer = {}
        good = GBuffer(
            data,
            &depthBuffer,
            swapchain.formats.depth,
            screen.width, screen.height,
            .OPTIMAL,
            { .DEPTH_STENCIL_ATTACHMENT },
            { .DEVICE_LOCAL },
            { .DEPTH }
        )
        if !good {
            log.panic("Failed to create Depth Buffer!")
        }
        gBuffers["light.depth"] = depthBuffer
    }

    return
}

GBuffer :: proc(
    data:       ^t.VulkanData            = nil,
    gBuffer:    ^t.GBuffer               = nil,
    format:     vk.Format                = .R8G8B8A8_SINT,
    width:      u32                      = 0,
    height:     u32                      = 0,
    tiling:     vk.ImageTiling           = .OPTIMAL,
    usage:      vk.ImageUsageFlags       = {},
    memoryFlags: vk.MemoryPropertyFlags  = {},
    aspectMask: vk.ImageAspectFlags      = {},
) -> (good: bool = true) {
    using data;
    context = ctx
    log.debug("Creating GBuffer")

    gBuffer.img, good = Image(
        data,
        width, height,
        &gBuffer.mem,
        memoryFlags,
        format,
        usage
    )
    if !good {
        log.panic("Failed to create GBuffer!")
    }

    gBuffer.view, good = ImageView(
        data,
        gBuffer.img,
        format,
        aspectMask
    )
    if !good {
        log.panic("Failed to create GBuffer View!")
    }

    return
}
