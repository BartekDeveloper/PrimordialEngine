package vk_destroy 

import "core:log"
import "core:mem"
import "core:c"
import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import rn "base:runtime"

import vk "vendor:vulkan"

import t "../types"

Instance :: proc(
    data: ^t.VulkanData = nil
) -> () {
    log.debug("Destroying Instance")

    if data.instance.messenger != {} {
        data.instance.messengerInfo = {}
        vk.DestroyDebugUtilsMessengerEXT(
            data.instance.instance,
            data.instance.messenger,
            data.allocations
        )
    }

    if data.instance.instance != {} {
        data.instance.createInfo = {}
        vk.DestroyInstance(
            data.instance.instance,
            data.allocations
        )
    }

    return
}
