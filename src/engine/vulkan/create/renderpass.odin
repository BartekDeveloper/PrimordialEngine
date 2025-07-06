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

RenderPasses :: proc(data: ^t.VulkanData) -> () {
    using data

    swapchain.formats.depth = choose.SwapchainDepthFormat(data)

    log.debug("Creating Render Passes")
    {
        passes["geometry"] = {}
        geometryPass := &passes["geometry"]

        log.debug("\t\t Color Attachment")
        geometryPass.color.attachments = []vk.AttachmentDescription{
            /* Position */
            AttachmentDescription(
                .R32G32B32A32_SFLOAT,
                finalLayout = .SHADER_READ_ONLY_OPTIMAL,
                initialLayout = .UNDEFINED
            ),
            /* Albedo */
            AttachmentDescription(
                .R16G16B16A16_UNORM,
                finalLayout = .SHADER_READ_ONLY_OPTIMAL,
                initialLayout = .UNDEFINED
            ),
            /* Normal */
            AttachmentDescription(
                .R8G8B8A8_SINT,
                finalLayout = .SHADER_READ_ONLY_OPTIMAL,
                initialLayout = .UNDEFINED
            ),
        }

        geometryPass.color.references = []vk.AttachmentReference{
            t.vkar{
                attachment = 0,
                layout     = .COLOR_ATTACHMENT_OPTIMAL
            },
            t.vkar{
                attachment = 1,
                layout     = .COLOR_ATTACHMENT_OPTIMAL
            },
            t.vkar{
                attachment = 2,
                layout     = .COLOR_ATTACHMENT_OPTIMAL
            }
        }

        log.debug("\t\t Depth Attachment")
        geometryPass.depth.attachment = AttachmentDescription(
            swapchain.formats.depth,
            finalLayout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL
        )

        geometryPass.depth.reference = t.vkar{
            attachment = 3,
            layout     = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL
        }

        log.debug("\t\t Subpass")
        geometryPass.subpasses = []vk.SubpassDescription{
            Subpass(
                u32(len(geometryPass.color.references)),
                raw_data(geometryPass.color.references),
                &geometryPass.depth.reference
            )
        }

        log.debug("\t\t Attachments")
        geometryPass.attachments = []vk.AttachmentDescription{
            geometryPass.color.attachments[0], // Position
            geometryPass.color.attachments[1], // Albedo
            geometryPass.color.attachments[2], // Normals
            geometryPass.depth.attachment      // Depth
        }

        log.debug("\t\t Create Info")
        geometryPass.createInfo = {
            sType           = .RENDER_PASS_CREATE_INFO,
            attachmentCount = u32(len(geometryPass.attachments)),
            pAttachments    = raw_data(geometryPass.attachments),
            subpassCount    = u32(len(geometryPass.subpasses)),
            pSubpasses      = raw_data(geometryPass.subpasses),
            dependencyCount = 0,
            pDependencies   = nil,
        }

        log.debug("\t\t Create `Geometry` Render Pass")
        good := RenderPass(
            data,
            &geometryPass.createInfo,
            &geometryPass.renderPass
        )
        if !good {
            panic("Failed to create Render Pass!")
        }
        assert(geometryPass.renderPass != {}, "Render Pass is nil!")

        Label_single(
            logical.device,
            "render pass - geometry",
            geometryPass.renderPass,
            .RENDER_PASS
        )
    }

    log.debug("\t Light Pass")
    {
        passes["light"] = {}
        lightPass := &passes["light"]

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
                srcSubpass      = vk.SUBPASS_EXTERNAL,
                dstSubpass      = 0,
                srcStageMask    = { .COLOR_ATTACHMENT_OUTPUT },
                dstStageMask    = { .FRAGMENT_SHADER },
                srcAccessMask   = { .COLOR_ATTACHMENT_WRITE },
                dstAccessMask   = { .SHADER_READ },
                dependencyFlags = { .BY_REGION },
            ),
        }

        log.debug("\t\t Attachments")
        lightPass.attachments = []vk.AttachmentDescription{
            lightPass.color.attachments[0],
            lightPass.depth.attachment
        }

        log.debug("\t\t Create Info")
        lightPass.createInfo = {
            sType           = .RENDER_PASS_CREATE_INFO,
            attachmentCount = u32(len(lightPass.attachments)),
            pAttachments    = raw_data(lightPass.attachments),
            subpassCount    = u32(len(lightPass.subpasses)),
            pSubpasses      = raw_data(lightPass.subpasses),
            dependencyCount = u32(len(lightPass.dependencies)),
            pDependencies   = raw_data(lightPass.dependencies),
        }

        log.debug("\t\t Creating Render Pass")
        good := RenderPass(
            data,
            &lightPass.createInfo,
            &lightPass.renderPass
        )
        if !good {
            panic("Failed to create Render Pass!")
        }
        assert(lightPass.renderPass != {}, "Render Pass is nil!")

        Label_single(
            logical.device,
            "render pass - light",
            lightPass.renderPass,
            .RENDER_PASS
        )
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
    srcSubpass: u32                     = vk.SUBPASS_EXTERNAL,
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
    result := vk.CreateRenderPass(data.logical.device, createInfo, data.allocations, renderPass)
    if result != .SUCCESS {
        good = false
    }
    return
}