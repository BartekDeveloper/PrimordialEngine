package vk_create

import "core:log"
import "core:c"

import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"

AdditionalData :: proc(data: ^t.VulkanData) -> () {
    using data;
    log.debug("Creating Additional Data")

    return
}