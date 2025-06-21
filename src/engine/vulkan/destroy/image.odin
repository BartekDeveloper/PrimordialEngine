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

Image :: #force_inline proc(
    data: ^t.VulkanData = nil,
    image: ^vk.Image    = nil,
    ctx: rn.Context     = {}
) -> () {
    vk.DestroyImage(
        data.logical.device,
        image^,
        data.allocations
    )
    return
}
