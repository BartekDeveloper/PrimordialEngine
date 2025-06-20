package vk_destroy 

import "core:log"
import "core:mem"
import "core:c"
import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

import vk "vendor:vulkan"

import t "../types"

Resources :: proc(
    data: ^t.VulkanData = nil
) -> () {

    return
}
