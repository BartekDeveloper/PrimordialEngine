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

CommandPools :: proc(data: ^t.VulkanData) -> () {
    using data;
    log.debug("Creating Command Pools")

    log.debug("\t Global Graphics Command Pool")
    {
        globalPool := commandPools["global"]
        
        globalPool.createInfo = vk.CommandPoolCreateInfo{
            sType            = .COMMAND_POOL_CREATE_INFO,
            flags            = { .RESET_COMMAND_BUFFER, .TRANSIENT },
            queueFamilyIndex = physical.queues.idx.graphics
        }

        good := CommandPool(data, &globalPool.createInfo, &globalPool.this)
        if !good {
            panic("Fai led to create Command Pool!")
        }

        commandPools["global"] = globalPool
    }
    
    return
}

CommandPool :: proc(
    data:       ^t.VulkanData            = nil,
    createInfo: ^vk.CommandPoolCreateInfo = nil,
    pool:       ^vk.CommandPool           = nil
) -> (good: bool = true) {

    result := vk.CreateCommandPool(data.logical.device, createInfo, nil, pool)
    if result != .SUCCESS {
        good = false
    }
    return
}

