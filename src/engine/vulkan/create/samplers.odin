package vk_create

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"

Samplers :: proc(data: ^t.VulkanData) -> () {
    using data;
    log.debug("Creating Samplers")

    good: bool = true

    return
}