package vk_create

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"

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