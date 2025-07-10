package vk_util

import "core:log"
import "core:c"

import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import s "../../../shared"

Transition :: proc(
    data: ^t.VulkanData             = nil,
    cmd: vk.CommandBuffer           = nil,
    image: vk.Image                 = 0,
    srcStage: vk.PipelineStageFlag = .COLOR_ATTACHMENT_OUTPUT,
    dstStage: vk.PipelineStageFlag = .FRAGMENT_SHADER,
    srcAccessMask: vk.AccessFlags   = { .COLOR_ATTACHMENT_WRITE },
    dstAccessMask: vk.AccessFlags   = { .SHADER_READ },
    srcLayout: vk.ImageLayout       = .COLOR_ATTACHMENT_OPTIMAL,
    dstLayout: vk.ImageLayout       = .GENERAL,
    srcQueueFamilyIndex: u32        = 0,
    dstQueueFamilyIndex: u32        = 0,
    aspectMask: vk.ImageAspectFlags = { .COLOR },
    baseMipLevel: u32               = 0,
    levelCount: u32                 = 1,
    baseArrayLayer: u32             = 0,
    layerCount: u32                 = 1,
) -> () {
    imageBarrier: vk.ImageMemoryBarrier = {
        sType                   = .IMAGE_MEMORY_BARRIER,
        oldLayout               = srcLayout,
        newLayout               = dstLayout,
        srcQueueFamilyIndex     = srcQueueFamilyIndex,
        dstQueueFamilyIndex     = dstQueueFamilyIndex,
        image                   = image,
        subresourceRange        = {
            aspectMask     = aspectMask,
            baseMipLevel   = baseMipLevel,
            levelCount     = levelCount,
            baseArrayLayer = baseArrayLayer,
            layerCount     = layerCount,
        },
        srcAccessMask           = srcAccessMask,
        dstAccessMask           = dstAccessMask,
    }

    vk.CmdPipelineBarrier(
        cmd,
        { srcStage },
        { dstStage }, 
        nil,
        0, nil,
        0, nil,
        1, &imageBarrier,
    )

    return
}

TransitionGBuffers_step1 :: proc(data: ^t.VulkanData) {
    using data
    log.debug("Transitioning Geometry GBuffers")
    cmd := BeginSingleTimeCommands(data)
    for i := 0; i < int(data.swapchain.imageCount); i += 1 {
        Transition(
            data,
            cmd,
            gBuffers["geometry.position"].images[i],
            .TOP_OF_PIPE,
            .COLOR_ATTACHMENT_OUTPUT,
            {},
            { .COLOR_ATTACHMENT_WRITE },
            .UNDEFINED,
            .GENERAL,
            aspectMask = { .COLOR },
        )
        Transition(
            data,
            cmd,
            gBuffers["geometry.albedo"].images[i],
            .TOP_OF_PIPE,
            .COLOR_ATTACHMENT_OUTPUT,
            {},
            { .COLOR_ATTACHMENT_WRITE },
            .UNDEFINED,
            .GENERAL,
            aspectMask = { .COLOR },
        )
        Transition(
            data,
            cmd,
            gBuffers["geometry.normal"].images[i],
            .TOP_OF_PIPE,
            .COLOR_ATTACHMENT_OUTPUT,
            {},
            { .COLOR_ATTACHMENT_WRITE },
            .UNDEFINED,
            .GENERAL,
            aspectMask = { .COLOR },
        )
    }
    EndSingleTimeCommands(data, &cmd)
}
