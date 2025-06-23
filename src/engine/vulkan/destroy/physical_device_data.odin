package vk_destroy 

import "core:log"
import "core:mem"
import "core:c"

import "core:fmt"
import "core:strings"
import "core:strconv"

import vk "vendor:vulkan"

import t "../types"

PhysicalDeviceData :: proc(
    data: ^t.VulkanData = nil
) -> () {
    using data
    
    physical.capabilities     = {}
    physical.properties       = {}
    physical.memoryProperties = {}
    physical.formats          = {}
    physical.modes            = {}
    physical.device           = {}
    delete(physical.uniqueQueueFamilies)

    return
}
