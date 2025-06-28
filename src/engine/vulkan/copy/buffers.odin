package vk_copy

import "core:fmt"
import "core:mem"
import vk "vendor:vulkan"

import t "../types"
import "../create"

ToBuffer_vulkan :: proc(
    data: ^t.VulkanData,
    buffer: vk.Buffer,
    memory: vk.DeviceMemory,
    srcData: rawptr,
    size: vk.DeviceSize,
) -> () {    
    using data
    
    dataPtr: rawptr
    result := vk.MapMemory(logical.device, memory, 0, size, {}, &dataPtr)
    if result != .SUCCESS {
        fmt.eprintfln("Failed to map memory! Result: {}", result)
        return
    }

    mem.copy(dataPtr, srcData, int(size))
    vk.UnmapMemory(logical.device, memory)
    
    return
}

ToBuffer_unified :: proc(
    data: ^t.VulkanData,
    buffer: ^t.Buffer,
    srcData: rawptr,
    size: vk.DeviceSize,
) -> () {    
    using data
    
    result := vk.MapMemory(logical.device, buffer.mem, buffer.offset, size, {}, &buffer.ptr)
    if result != .SUCCESS {
        fmt.eprintfln("Failed to map memory! Result: {}", result)
        return
    }

    mem.copy(buffer.ptr, srcData, int(size))
    vk.UnmapMemory(logical.device, buffer.mem)

    return
}

ToBuffer :: proc{
    ToBuffer_vulkan,
    ToBuffer_unified,
}

