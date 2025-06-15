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
    lightPass := passes["light"]
    {
        using lightPass;
        
        frameBuffers = make([]vk.Framebuffer, swapchain.imageCount)
        for i := 0; i < int(swapchain.imageCount); i += 1 {
            attachments: []vk.ImageView = {
                swapchain.views[i],
                gBuffers["light.depth"].view,
            }

            framebufferCreateInfo: vk.FramebufferCreateInfo = {
                sType           = .FRAMEBUFFER_CREATE_INFO,
                renderPass      = renderPass,
                attachmentCount = u32(len(attachments)),
                pAttachments    = raw_data(attachments),
                width           = screen.width,
                height          = screen.height,
                layers          = 1,
            }

            result := vk.CreateFramebuffer(logical.device, &framebufferCreateInfo, nil, &frameBuffers[i])
            if result != .SUCCESS {
                log.error("Failed to create framebuffer!")
            }
            fmt.eprintln("Created `light` Framebuffer #%d", i) 
        }
    }

    return  
}