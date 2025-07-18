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

ImageView :: #force_inline proc(
    data: ^t.VulkanData = nil,
    view: ^vk.ImageView = nil,
    ctx: rn.Context     = {}
) -> () {
    
    vk.DestroyImageView(
        data.logical.device,
        view^,
        data.allocations
    )
    return
}
