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

Swapchain :: proc(
    data: ^t.VulkanData = nil
) -> () {
    Resources(data)

    log.debug("Destroying Swapchain Images")
    for &view in data.swapchain.views {
        vk.DestroyImageView(
            data.logical.device,
            view,
            data.allocations
        )
        assert(view != {}, "Swapchain View is not nil!")
    }

    log.debug("Destroying Swapchain")
    vk.DestroySwapchainKHR(
        data.logical.device,
        data.swapchain.swapchain,
        data.allocations
    )
    assert(data.swapchain.swapchain != {}, "Swapchain is not nil!")

    return
}
