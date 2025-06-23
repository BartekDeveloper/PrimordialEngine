package vk_create

import "core:log"

import vk "vendor:vulkan"

import t   "../types"
import win "../../window"

Surface :: proc(data: ^t.VulkanData) -> () {
    using data
    
    log.info("Creating Vulkan Surface")
    win.VulkanCreateSurface(&instance.instance, &surface, allocations=allocations)
    log.info("Created Surface!")

    return
}
