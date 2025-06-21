package vk_destroy 

import "core:log"
import "core:mem"
import "core:c"
import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

import vk "vendor:vulkan"

import t "../types"

CommandPools :: proc(
    data: ^t.VulkanData = nil
) -> () {
    log.debug("\tDestroying Command Pools")
    
    for k, &pool in data.commandPools {
        log.debugf("\t\t * %s", k)
        CommandPool(
            data,
            &pool
        )
    }
    return
}

CommandPool :: proc(
    data: ^t.VulkanData = nil,
    pool: ^t.CommandPool = nil
) -> () {
    pool.createInfo = {}
    if pool.this != {} {
        vk.DestroyCommandPool(
            data.logical.device,
            pool.this,
            data.allocations
        )
    }
    return
}