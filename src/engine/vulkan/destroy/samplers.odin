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

Samplers :: proc(
    data: ^t.VulkanData = nil
) -> () {
    log.debug("\t\tDestroying samplers")

    for _, &sampler in data.samplers {
        vk.DestroySampler(
            data.logical.device,
            sampler,
            data.allocations
        )
    }

    log.debug("\tDestroying Samplers")
    return
}
