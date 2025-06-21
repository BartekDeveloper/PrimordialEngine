package vk_create

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import "../choose"
import t   "../types"
import win "../../window"

CommandBuffers :: proc(
    data: ^t.VulkanData
) -> () {
    using data;
    log.debug("Creating Command Buffers")

    globalPool := commandPools["global"]
    imageCount := u32(swapchain.imageCount)

    log.debug("\t Global Graphics Command Buffer")
    {
        globalCmdBuffer := commandBuffers["global"]

        globalCmdBuffer.createInfo = vk.CommandBufferAllocateInfo{
            sType              = .COMMAND_BUFFER_ALLOCATE_INFO,
            commandPool        = globalPool.this,
            level              = .PRIMARY,
            commandBufferCount = imageCount,
        }
        globalCmdBuffer.this = make([]vk.CommandBuffer, imageCount)

        good := CommandBuffer(
            data,
            &globalCmdBuffer.createInfo,
            raw_data(globalCmdBuffer.this)
        )
        if !good {
            panic("Failed to create Command Buffer!")
        }

        commandBuffers["global"] = globalCmdBuffer
    }
    
    return
}

CommandBuffer :: proc(
    data:        ^t.VulkanData                 = nil,
    createInfo:  ^vk.CommandBufferAllocateInfo = nil,
    cmdBuffer_s: [^]vk.CommandBuffer           = nil 
) -> (good: bool = true) {
    using data;

    result := vk.AllocateCommandBuffers(
        logical.device,
        createInfo,
        cmdBuffer_s
    )
    if result != .SUCCESS {
        good = false
    }
    return
}