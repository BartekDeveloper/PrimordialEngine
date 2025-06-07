package vk_create

import "core:log"

import vk "vendor:vulkan"

import t "../types"

AppInfo :: proc(data: ^t.VulkanData, loc := #caller_location) -> () {
    log.infof("\t%s", loc)

    data.appInfo = {
        sType              = .APPLICATION_INFO,
        pApplicationName   = "PE",
        applicationVersion = vk.MAKE_VERSION(1, 0, 0),
        pEngineName        = "PE",
        engineVersion      = vk.MAKE_VERSION(1, 0, 0),
        apiVersion         = vk.API_VERSION_1_0
    }

    return
}
