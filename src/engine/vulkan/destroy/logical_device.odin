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

LogicalDevice :: proc "fastcall" (
    data: ^t.VulkanData = nil,
    ctx: rn.Context = {}
) -> () {
    context = ctx
    log.debug("Destroying Logical Device")

    vk.DestroyDevice(
        data.logical.device,
        data.allocations
    )
    return
}
