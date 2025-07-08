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
        passes["combined"] = {};
        combinedPass := &passes["combined"];

        log.debug("\t Color Attachments (G-buffer)");
        combinedPass.color.attachments = []vk.AttachmentDescription{
            // Position
            AttachmentDescription(
                .R32G32B32A32_SFLOAT,
                finalLayout = .GENERAL,
                initialLayout = .UNDEFINED,
            ),
            // Albedo
            AttachmentDescription(
                .R16G16B16A16_UNORM,
                finalLayout = .GENERAL,
                initialLayout = .UNDEFINED,
            ),
            // Normal
            AttachmentDescription(
                .R8G8B8A8_SINT,
                finalLayout = .GENERAL,
                initialLayout = .UNDEFINED,
            ),
            // Swapchain Color
            AttachmentDescription(
                swapchain.formats.surface.format,
                finalLayout = .PRESENT_SRC_KHR,
                initialLayout = .UNDEFINED
            ),
        };

        combinedPass.color.references = []vk.AttachmentReference{
            t.vkar{ attachment = 0, layout = .COLOR_ATTACHMENT_OPTIMAL },
            t.vkar{ attachment = 1, layout = .COLOR_ATTACHMENT_OPTIMAL },
            t.vkar{ attachment = 2, layout = .COLOR_ATTACHMENT_OPTIMAL },
            t.vkar{ attachment = 3, layout = .COLOR_ATTACHMENT_OPTIMAL },
        };

        log.debug("\t Depth Attachment");
        combinedPass.depth.attachment = AttachmentDescription(
            swapchain.formats.depth,
            finalLayout = .GENERAL,
            initialLayout = .UNDEFINED,
        );

        combinedPass.depth.reference = t.vkar{
            attachment = 4,
            layout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
        };

        subpass1ColorReferences: []vk.AttachmentReference ={ 
            combinedPass.color.references[0],
            combinedPass.color.references[1],
            combinedPass.color.references[2],
            combinedPass.color.references[3],
        }

        subpass2ColorReferences: []vk.AttachmentReference ={ 
            combinedPass.color.references[3],
        }
        
        subpass2InputReferences: []vk.AttachmentReference = {
            t.vkar{ attachment = 0, layout = .GENERAL },
            t.vkar{ attachment = 1, layout = .GENERAL },
            t.vkar{ attachment = 2, layout = .GENERAL },
        };

        log.debug("\t Subpasses");
        combinedPass.subpasses = []vk.SubpassDescription{
            // Subpass 0: G-buffer rendering (first 3 color attachments + depth)
            Subpass(
                3,
                raw_data(subpass1ColorReferences),
                &combinedPass.depth.reference,
                nil,
                .GRAPHICS,
            ),
            // Subpass 1: Lighting pass (uses swapchain color attachment)
            Subpass(
                1,
                raw_data(subpass2ColorReferences),
                nil,
                nil,
                .GRAPHICS,
                3,
                raw_data(subpass2InputReferences),
            ),
        };

        log.debug("\t Dependencies");
        combinedPass.dependencies = []vk.SubpassDependency{
            // Subpass 0 -> Subpass 1
            SubpassDependency(
                srcSubpass      = 0,
                dstSubpass      = 1,
                srcStageMask    = { .COLOR_ATTACHMENT_OUTPUT },
                dstStageMask    = { .FRAGMENT_SHADER         },
                srcAccessMask   = { .COLOR_ATTACHMENT_WRITE  },
                dstAccessMask   = { .SHADER_READ             },
                dependencyFlags = { .BY_REGION               },
            ),
        };

        log.debug("\t Attachments");
        combinedPass.attachments = []vk.AttachmentDescription{
            combinedPass.color.attachments[0],
            combinedPass.color.attachments[1],
            combinedPass.color.attachments[2],
            combinedPass.color.attachments[3],
            combinedPass.depth.attachment,
        };

        log.debug("\t Create Info");
        combinedPass.createInfo = vk.RenderPassCreateInfo{
            sType           = .RENDER_PASS_CREATE_INFO,
            attachmentCount = u32(len(combinedPass.attachments)),
            pAttachments    = raw_data(combinedPass.attachments),
            subpassCount    = u32(len(combinedPass.subpasses)),
            pSubpasses      = raw_data(combinedPass.subpasses),
            dependencyCount = u32(len(combinedPass.dependencies)),
            pDependencies   = raw_data(combinedPass.dependencies),
        };

        log.debug("\t Creating Render Pass - combined");
        RenderPass(
            data,
            &combinedPass.createInfo,
            &combinedPass.renderPass,
        )
        assert(combinedPass.renderPass != {}, "Combined Render Pass is nil!");

        Label_single(
            data.logical.device,
            "render pass - combined",
            combinedPass.renderPass,
            .RENDER_PASS,
        );
    }

    return
}

AttachmentDescription :: proc(
    format: vk.Format                    = .R8G8B8A8_UNORM,
    loadOp: vk.AttachmentLoadOp          = .CLEAR,
    storeOp: vk.AttachmentStoreOp        = .STORE,
    finalLayout: vk.ImageLayout          = .GENERAL,
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
    #any_int color_count: u32,
    colorAttachments: [^]vk.AttachmentReference = nil,
    depthAttachment:  ^vk.AttachmentReference   = nil,
    resolve:          [^]vk.AttachmentReference = nil,
    point:            vk.PipelineBindPoint      = .GRAPHICS,
    #any_int input_count: u32 = 0,
    inputAttachments: [^]vk.AttachmentReference = nil,
) -> (subpass: vk.SubpassDescription) {
    return {
        pipelineBindPoint       = point,
        colorAttachmentCount    = color_count,
        pColorAttachments       = nil if (color_count == 0) else colorAttachments,
        pResolveAttachments     = nil if (color_count == 0) else resolve,
        pDepthStencilAttachment = depthAttachment,
        inputAttachmentCount    = input_count,
        pInputAttachments       = nil if (input_count == 0) else inputAttachments,
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
) -> () {
    result := vk.CreateRenderPass(
        data.logical.device,
        createInfo,
        data.allocations,
        renderPass
    ); if result != .SUCCESS {
        fmt.eprintfln("{}", result)
        panic("Failed to create combined Render Pass!");
    }

    return
}