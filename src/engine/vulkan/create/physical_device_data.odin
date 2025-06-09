package vk_create

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import     "../choose"
import t   "../types"
import win "../../window"

PhysicalDeviceData :: proc(data: ^t.VulkanData) -> () {
    using data;

    chosen := choose.PhysicalDevicesData(instance.instance, surface)
    assert(chosen.device != nil, "Selected handle is nil!")
    
    physical = chosen
}
