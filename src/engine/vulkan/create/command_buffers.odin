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