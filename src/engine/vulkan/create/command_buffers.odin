package vk_create

import "core:log"
import "core:c"

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
    using data
    log.debug("Creating Command Buffers")

    globalPool := commandPools["global"]
    MAX_FRAMES_IN_FLIGHT := u32(data.renderData.MAX_FRAMES_IN_FLIGHT)

    {
        log.debug("\t Global Graphics Command Buffer")

        commandBuffers["global"] = {}
        cmd := &commandBuffers["global"]

        cmd.createInfo = vk.CommandBufferAllocateInfo{
            sType              = .COMMAND_BUFFER_ALLOCATE_INFO,
            commandPool        = globalPool.this,
            level              = .PRIMARY,
            commandBufferCount = MAX_FRAMES_IN_FLIGHT,
        }
        cmd.this = make([]vk.CommandBuffer, MAX_FRAMES_IN_FLIGHT)

        good := CommandBuffer(
            data,
            &cmd.createInfo,
            raw_data(cmd.this)
        )
        if !good {
            panic("Failed to create Command Buffer!")
        }
    }
    
    return
}

CommandBuffer :: proc(
    data:        ^t.VulkanData                 = nil,
    createInfo:  ^vk.CommandBufferAllocateInfo = nil,
    cmdBuffer_s: [^]vk.CommandBuffer           = nil 
) -> (good: bool = true) {
    using data

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

OneTimeSubmit :: proc(
    data: ^t.VulkanData,
    command: proc(cmd: vk.CommandBuffer),
) {
    using data

    allocInfo := vk.CommandBufferAllocateInfo{
        sType              = .COMMAND_BUFFER_ALLOCATE_INFO,
        level              = .PRIMARY,
        commandPool        = commandPools["global"].this,
        commandBufferCount = 1,
    }

    cmdBuffer: vk.CommandBuffer
    vk.AllocateCommandBuffers(logical.device, &allocInfo, &cmdBuffer)

    beginInfo := vk.CommandBufferBeginInfo{
        sType = .COMMAND_BUFFER_BEGIN_INFO,
        flags = { .ONE_TIME_SUBMIT },
    }

    vk.BeginCommandBuffer(cmdBuffer, &beginInfo)

    command(cmdBuffer)

    vk.EndCommandBuffer(cmdBuffer)

    submitInfo := vk.SubmitInfo{
        sType              = .SUBMIT_INFO,
        commandBufferCount = 1,
        pCommandBuffers    = &cmdBuffer,
    }

    vk.QueueSubmit(
        physical.queues.graphics,
        1,
        &submitInfo,
        {}
        )
    vk.QueueWaitIdle(physical.queues.graphics)
    vk.FreeCommandBuffers(logical.device, commandPools["global"].this, 1, &cmdBuffer)
}
