package vk_create

import "core:log"
import "core:c"

import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import "../choose"
import t "../types"
import win "../../window"

Resources :: proc(data: ^t.VulkanData) -> () {
    using data
    good: bool = true

    swapchain.formats.color = swapchain.formats.surface.format
    screen := swapchain.extent
    
    gBuffers["light.color"] = {}
    gBuffers["light.depth"] = {}
    
    lightPass   := &passes["light"]
    colorBuffer := &gBuffers["light.color"]
    depthBuffer := &gBuffers["light.depth"]

    log.debug("Creating Resources")
    log.debug("\t Color Buffer")
    good = GBuffer(
        data,
        colorBuffer,
        swapchain.formats.color,
        screen.width, screen.height,
        .OPTIMAL,
        { .COLOR_ATTACHMENT },
        { .DEVICE_LOCAL },
        { .COLOR }
    )
    if !good {
        panic("Failed to create Color Buffer!")
    }

    log.debug("\t Depth Buffer")
    good = GBuffer(
        data,
        depthBuffer,
        swapchain.formats.depth,
        screen.width, screen.height,
        .OPTIMAL,
        { .DEPTH_STENCIL_ATTACHMENT },
        { .DEVICE_LOCAL },
        { .DEPTH }
    )
    if !good {
        panic("Failed to create Depth Buffer!")
    }

    return
}

GBuffer :: proc(
    data:       ^t.VulkanData            = nil,
    gBuffer:    ^t.GBuffer               = nil,
    format:     vk.Format                = .R8G8B8A8_SINT,
    width:      u32                       = 0,
    height:     u32                      = 0,
    tiling:     vk.ImageTiling           = .OPTIMAL,
    usage:      vk.ImageUsageFlags       = {},
    memoryFlags: vk.MemoryPropertyFlags  = {},
    aspectMask: vk.ImageAspectFlags      = {},
) -> (good: bool = true) {
    using data
    log.debug("Creating GBuffer")

    gBuffer.images = make([]vk.Image,        data.swapchain.imageCount)
    gBuffer.views  = make([]vk.ImageView,    data.swapchain.imageCount)
    gBuffer.mems   = make([]vk.DeviceMemory, data.swapchain.imageCount)

    for i := 0; i < int(data.swapchain.imageCount); i += 1 {
        gBuffer.images[i], good = Image(
            data,
            width, height,
            &gBuffer.mems[i],
            memoryFlags,
            format,
            usage
        )
        if !good {
            panic("Failed to create GBuffer!")
        }

        gBuffer.views[i], good = ImageView(
            data,
            gBuffer.images[i],
            format,
            aspectMask
        )
        if !good {
            panic("Failed to create GBuffer View!")
        }
    }

    return
}
