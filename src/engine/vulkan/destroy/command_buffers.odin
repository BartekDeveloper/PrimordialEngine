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

CommandBuffers :: proc(
    data: ^t.VulkanData = nil
) -> () {
    log.debug("\tDestroying Command Buffers")

    for _, &cmd in data.commandBuffers {
        delete(cmd.this)
    }

    delete(data.commandBuffers)

    return
}
