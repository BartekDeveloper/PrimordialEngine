package vk_util

import "core:log"
import "core:c"

import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"

BeginSingleTimeCommands :: proc(data: ^t.VulkanData) -> (cmd: vk.CommandBuffer) {
    using data

    allocInfo: vk.CommandBufferAllocateInfo = {
        sType              = .COMMAND_BUFFER_ALLOCATE_INFO,
        level              = .PRIMARY,
        commandPool        = commandPools["global"].this,
        commandBufferCount = 1,
    }

    vk.AllocateCommandBuffers(logical.device, &allocInfo, &cmd)

    beginInfo: vk.CommandBufferBeginInfo = {
        sType = .COMMAND_BUFFER_BEGIN_INFO,
        flags = { .ONE_TIME_SUBMIT },
    }

    vk.BeginCommandBuffer(cmd, &beginInfo)

    return cmd
}

EndSingleTimeCommands :: proc(data: ^t.VulkanData, cmd: ^vk.CommandBuffer) {
    using data

    vk.EndCommandBuffer(cmd^)

    submitInfo: vk.SubmitInfo = {
        sType              = .SUBMIT_INFO,
        commandBufferCount = 1,
        pCommandBuffers    = cmd,
    }

    globalPool := &commandPools["global"]

    vk.QueueSubmit(physical.queues.graphics, 1, &submitInfo, {})
    vk.QueueWaitIdle(physical.queues.graphics)

    vk.FreeCommandBuffers(logical.device, globalPool.this, 1, cmd)
}
