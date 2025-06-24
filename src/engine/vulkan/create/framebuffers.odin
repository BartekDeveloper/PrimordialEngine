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

Framebuffers :: proc(data: ^t.VulkanData) -> () {
    using data
    log.debug("Creating Framebuffers")

    screen    := swapchain.extent
    screen3D  := vk.Extent3D{ width = screen.width, height = screen.height, depth = 1 }
    
    geometryPass := &passes["geometry"]
    {
        geometryPass.frameBuffers = make([]vk.Framebuffer, swapchain.imageCount)

        for &fb, i in geometryPass.frameBuffers {
            log.assertf(gBuffers["geometry.position"].views[i] != {}, "Geometry Position Buffer View is nil at index %d", i)
            log.assertf(gBuffers["geometry.albedo"].views[i]   != {}, "Geometry Albedo Buffer View is nil at index %d", i)
            log.assertf(gBuffers["geometry.normal"].views[i]   != {}, "Geometry Normal Buffer View is nil at index %d", i)
            log.assertf(gBuffers["geometry.depth"].views[i]    != {}, "Geometry Depth Buffer View is nil at index %d", i)

            attachments: []vk.ImageView = {
                gBuffers["geometry.position"].views[i], // Attachment 0: Position
                gBuffers["geometry.albedo"].views[i],   // Attachment 1: Albedo
                gBuffers["geometry.normal"].views[i],   // Attachment 2: Normal
                gBuffers["geometry.depth"].views[i],    // Attachment 3: Depth
            }

            FrameBuffer(
                data,
                screen3D,
                geometryPass^,
                &attachments,
                &fb
            )

            fmt.eprintfln("Created `geometry` Framebuffer #%d", i)
        }

        fmt.eprintfln("Total created `geometry` Framebuffer count: %d", len(geometryPass.frameBuffers))
    }

    
    lightPass := &passes["light"]
    {  
        lightPass.frameBuffers = make([]vk.Framebuffer, swapchain.imageCount)
        for &fb, i in lightPass.frameBuffers {
            log.assertf(swapchain.views[i]           != {}, "Swapchain View #%d is nil!", i)
            log.assertf(gBuffers["light.depth"].views[i] != {}, "Light Depth Buffer View is nil!")

            attachments: []vk.ImageView = {
                swapchain.views[i],
                gBuffers["light.depth"].views[i],
            }

            FrameBuffer(
                data,
                screen3D,
                lightPass^,
                &attachments,
                &fb
            )
            fmt.eprintfln("Created `light` Framebuffer #%d", i) 
        }
        
        fmt.eprintfln("Total created `light` Framebuffer count: %d", len(lightPass.frameBuffers))  
    }

    return  
}

FrameBuffer :: proc(
    data:        ^t.VulkanData   = nil,
    size:        vk.Extent3D     = {},
    renderPass:  t.RenderPass    = {},
    attachments: ^[]vk.ImageView = nil,
    frameBuffer: ^vk.Framebuffer = nil,
) -> () {
    createInfo: vk.FramebufferCreateInfo = {
        sType           = .FRAMEBUFFER_CREATE_INFO,
        renderPass      = renderPass.renderPass,
        attachmentCount = u32(len(attachments)),
        pAttachments    = raw_data(attachments^),
        width           = size.width,
        height          = size.height,
        layers          = size.depth,
    }

    result := vk.CreateFramebuffer(
        data.logical.device,
        &createInfo,
        data.allocations,
        frameBuffer
    )
    if result != .SUCCESS {
        panic("Failed to create framebuffer!")
    }

    return
}