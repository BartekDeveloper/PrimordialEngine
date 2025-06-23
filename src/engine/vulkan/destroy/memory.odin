package vk_destroy 

import "core:log"
import "core:mem"
import "core:c"

import "core:fmt"
import "core:strings"
import "core:strconv"
import rn "base:runtime"

import vk "vendor:vulkan"

import t "../types"

Memory :: #force_inline proc(
    data: ^t.VulkanData      = nil,
    memory: ^vk.DeviceMemory = nil,
    ctx: rn.Context          = {}
) -> () {
    
    vk.FreeMemory(
        data.logical.device,
        memory^,
        data.allocations
    )
    return
}
