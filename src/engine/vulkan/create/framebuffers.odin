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

Framebuffers :: proc(data: ^t.VulkanData) -> () {
    using data;
    log.debug("Creating Framebuffers")

    screen    := swapchain.extent
    screen3D  := vk.Extent3D{ width = screen.width, height = screen.height, depth = 1 }
    lightPass := passes["light"]
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
                lightPass,
                &attachments,
                &fb
            )
            fmt.eprintfln("Created `light` Framebuffer #%d", i) 
            passes["light"] = lightPass
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