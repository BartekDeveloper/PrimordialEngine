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

AppInfo :: #force_inline proc(
    data: ^t.VulkanData = nil
) -> () {

    data.appInfo = {}
    assert(data.appInfo == {}, "Could not destroy AppInfo!")
    
    return
}
