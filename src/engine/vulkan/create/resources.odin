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
import utils "../utils"

Resources :: proc(data: ^t.VulkanData) -> () {
    using data
    good: bool = true

    swapchain.formats.color = swapchain.formats.surface.format
    screen := swapchain.extent
    
    gBuffers["geometry.position"] = {}
    gBuffers["geometry.albedo"]   = {}
    gBuffers["geometry.normal"]   = {}
    // gBuffers["light.color"]       = {}
    gBuffers["light.depth"]       = {}

    positionBuffer := &gBuffers["geometry.position"]
    albedoBuffer   := &gBuffers["geometry.albedo"]
    normalBuffer   := &gBuffers["geometry.normal"]
    
    // colorBuffer := &gBuffers["light.color"]
    depthBuffer := &gBuffers["light.depth"]

    positionBuffer.format = .R32G32B32A32_SFLOAT
    albedoBuffer.format   = .R16G16B16A16_UNORM
    normalBuffer.format   = .R8G8B8A8_SINT
    depthBuffer.format    = swapchain.formats.depth
    // colorBuffer.format    = swapchain.formats.color

    log.debug("Creating Resources")
    log.debug("\t `Geometry` GBuffers")
    log.debug("\t\t Position Buffer")
    good = GBuffer(
        data,
        positionBuffer,
        positionBuffer.format,
        screen.width, screen.height,
        .OPTIMAL,
        { .COLOR_ATTACHMENT, .SAMPLED },
        { .DEVICE_LOCAL },
        { .COLOR }
    )
    if !good {
        panic("Failed to create Position Buffer!")
    }
    Label(
        logical.device,
        "Geometry Position Buffer",
        positionBuffer
    )

    log.debug("\t\t Albedo Buffer")
    good = GBuffer(
        data,
        albedoBuffer,
        albedoBuffer.format,
        screen.width, screen.height,
        .OPTIMAL,
        { .COLOR_ATTACHMENT, .SAMPLED },
        { .DEVICE_LOCAL },
        { .COLOR }
    )
    if !good {
        panic("Failed to create Albedo Buffer!")
    }
    Label(
        logical.device,
        "Geometry Albedo Buffer",
        albedoBuffer
    )

    log.debug("\t\t Normal Buffer")
    good = GBuffer(
        data,
        normalBuffer,
        normalBuffer.format,
        screen.width, screen.height,
        .OPTIMAL,
        { .COLOR_ATTACHMENT, .SAMPLED },
        { .DEVICE_LOCAL },
        { .COLOR }
    )
    if !good {
        panic("Failed to create Normal Buffer!")
    }
    Label(
        logical.device,
        "Geometry Normal Buffer",
        normalBuffer
    )

    log.debug("\t `Light` GBuffers")
    // log.debug("\t\t Color Buffer")
    // good = GBuffer(
    //     data,
    //     colorBuffer,
    //     colorBuffer.format,
    //     screen.width, screen.height,
    //     .OPTIMAL,
    //     { .COLOR_ATTACHMENT },
    //     { .DEVICE_LOCAL },
    //     { .COLOR }
    // )
    // if !good {
    //     panic("Failed to create Color Buffer!")
    // }
    // Label(
    //     logical.device,
    //     "Light Color Buffer",
    //     colorBuffer
    // )

    log.debug("\t\t Depth Buffer")
    good = GBuffer(
        data,
        depthBuffer,
        depthBuffer.format,
        screen.width, screen.height,
        .OPTIMAL,
        { .DEPTH_STENCIL_ATTACHMENT, .SAMPLED },
        { .DEVICE_LOCAL },
        { .DEPTH, .STENCIL }
    )
    if !good {
        panic("Failed to create Depth Buffer!")
    }
    Label(
        logical.device,
        "Light Depth Buffer",
        depthBuffer
    )

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
