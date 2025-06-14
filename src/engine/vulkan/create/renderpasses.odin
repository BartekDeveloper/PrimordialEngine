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

RenderPasses :: proc(data: ^t.VulkanData) -> () {
    using data;
    ctx = context

    swapchain.formats.depth = choose.SwapchainDepthFormat(data)

    log.debug("Creating Render Passes")
    log.debug("\t Light Pass")
    {
        lightPass := passes["light"]

        log.debug("\t\t Color Attachment")
        lightPass.color.attachments = []vk.AttachmentDescription{
            AttachmentDescription(
                swapchain.formats.surface.format,
                finalLayout = .PRESENT_SRC_KHR
            )
        }
        lightPass.color.references = []vk.AttachmentReference{
            t.vkar{
                attachment = 0,
                layout     = .COLOR_ATTACHMENT_OPTIMAL
            }
        }

        log.debug("\t\t Depth Attachment")
        lightPass.depth.attachment = AttachmentDescription(
            swapchain.formats.depth,
            finalLayout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL
        )

        lightPass.depth.reference = t.vkar{
            attachment = 1,
            layout     = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL
        }

        log.debug("\t\t Subpass")
        lightPass.subpasses = []vk.SubpassDescription{
            Subpass(
                u32(len(lightPass.color.references)),
                raw_data(lightPass.color.references),
                &lightPass.depth.reference
            )
        }

        log.debug("\t\t Dependencies")
        lightPass.dependencies = []vk.SubpassDependency{
            SubpassDependency(
                { .COLOR_ATTACHMENT_OUTPUT },
                { .FRAGMENT_SHADER         },
                { .COLOR_ATTACHMENT_WRITE },
                { .SHADER_READ            },
                { .BY_REGION            }
            )
        }

        log.debug("\t\t Attachments")
        attachments: []vk.AttachmentDescription = {
            lightPass.color.attachments[0],
            lightPass.depth.attachment
        }

        log.debug("\t\t Create Info")
        lightPass.createInfo = {
            sType           = .RENDER_PASS_CREATE_INFO,
            attachmentCount = u32(len(attachments)),
            pAttachments    = raw_data(attachments),
            subpassCount    = u32(len(lightPass.subpasses)),
            pSubpasses      = raw_data(lightPass.subpasses),
            dependencyCount = u32(len(lightPass.dependencies)),
            pDependencies   = raw_data(lightPass.dependencies),
        }

        log.debug("\t\t Creating Render Pass")
        good := RenderPass(data, &lightPass.createInfo, &lightPass.renderPass)
        if !good {
            log.fatal("Failed to create Render Pass!")
        }
        
        passes["light"] = lightPass
    }

    return
}


AttachmentDescription :: proc(
    format: vk.Format                    = .R8G8B8A8_UNORM,
    loadOp: vk.AttachmentLoadOp          = .CLEAR,
    storeOp: vk.AttachmentStoreOp        = .STORE,
    finalLayout: vk.ImageLayout          = .SHADER_READ_ONLY_OPTIMAL,
    stencilLoadOp: vk.AttachmentLoadOp   = .DONT_CARE,
    stencilStoreOp: vk.AttachmentStoreOp = .DONT_CARE,
    initialLayout: vk.ImageLayout        = .UNDEFINED,
    samples: vk.SampleCountFlags         = {._1},
) -> (attachment: vk.AttachmentDescription) {
    return {
        format         = format,
        samples        = samples,
        loadOp         = loadOp,
        storeOp        = storeOp,
        stencilLoadOp  = stencilLoadOp,
        stencilStoreOp = stencilStoreOp,
        initialLayout  = initialLayout,
        finalLayout    = finalLayout,
    }
}

Subpass :: proc(
    #any_int count: u32,
    colorAttachments: [^]vk.AttachmentReference = nil,
    depthAttachment:  ^vk.AttachmentReference   = nil,
    resolve:          [^]vk.AttachmentReference = nil,
    point:            vk.PipelineBindPoint      = .GRAPHICS,
) -> (subpass: vk.SubpassDescription) {
    return {
        pipelineBindPoint       = point,
        colorAttachmentCount    = count,
        pColorAttachments       = nil if (count == 0) else colorAttachments,
        pResolveAttachments     = nil if (count == 0) else resolve,
        pDepthStencilAttachment = depthAttachment,
    }
}

SubpassDependency :: proc(
    srcStageMask: vk.PipelineStageFlags = {},
    dstStageMask: vk.PipelineStageFlags = {},
    srcAccessMask: vk.AccessFlags       = {},
    dstAccessMask: vk.AccessFlags       = {},
    dependencyFlags: vk.DependencyFlags = {},
    srcSubpass: u32                     = 0xFFFFFFFF,
    dstSubpass: u32                     = 0,
) -> (dependency: vk.SubpassDependency) {
    return {
        srcSubpass      = srcSubpass,
        dstSubpass      = dstSubpass,
        srcStageMask    = srcStageMask,
        srcAccessMask   = srcAccessMask,
        dstStageMask    = dstStageMask,
        dstAccessMask   = dstAccessMask,
        dependencyFlags = dependencyFlags,
    }
}

RenderPass :: proc(
    data:       ^t.VulkanData            = nil,
    createInfo: ^vk.RenderPassCreateInfo = nil,
    renderPass: ^vk.RenderPass           = nil
) -> (good: bool = true) {
    context = ctx

    result := vk.CreateRenderPass(data.logical.device, createInfo, nil, renderPass)
    if result != .SUCCESS {
        good = false
    }
    return
}