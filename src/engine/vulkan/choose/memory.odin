package vk_choose

import "core:log"
import vk "vendor:vulkan"

@(require_results)
MemoryType_return :: proc(
    physicalDevice: vk.PhysicalDevice  = nil,
    typeFilter: u32                    = 0,
    properties: vk.MemoryPropertyFlags = {}
) -> (memoryTypeIndex: u32, ok: bool) #optional_ok {

    memoryProperties: vk.PhysicalDeviceMemoryProperties
    vk.GetPhysicalDeviceMemoryProperties(physicalDevice, &memoryProperties)

    for i: u32 = 0; i < memoryProperties.memoryTypeCount; i += 1 {
        if b32(typeFilter & (1 << i)) && b32((memoryProperties.memoryTypes[i].propertyFlags & properties) == properties) {
            return i, true
        }
    }

    log.panic("Failed to find suitable memory type")
}

MemoryType_modify :: proc(
    physicalDevice: vk.PhysicalDevice  = nil,
    typeFilter: u32                    = 0,
    properties: vk.MemoryPropertyFlags = {},
    memoryTypeIndex: ^u32              = nil,
) -> (good: bool = true) {

    memoryProperties: vk.PhysicalDeviceMemoryProperties
    vk.GetPhysicalDeviceMemoryProperties(physicalDevice, &memoryProperties)

    for i: u32 = 0; i < memoryProperties.memoryTypeCount; i += 1 {
        if b32(typeFilter & (1 << i)) && b32((memoryProperties.memoryTypes[i].propertyFlags & properties) == properties) {
            memoryTypeIndex^ = i
            return true
        }
    }

    good = false
    log.error("Failed to find suitable memory type")
    return
}

MemoryType :: proc{
    MemoryType_return,
    MemoryType_modify,
}
