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

Surface :: proc "fastcall" (
    data: ^t.VulkanData = nil,
    ctx: rn.Context = {}
) -> () {
    context = ctx
    log.debug("Destroying Surface")
    
    if data.surface != {} {
        vk.DestroySurfaceKHR(
            data.instance.instance,
            data.surface,
            data.allocations
        )
    }

    return
}
