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
    using data;
    
    Resources(data)

    log.debug("Destroying Swapchain Image Views")
    for &view in swapchain.views {
        vk.DestroyImageView(
            logical.device,
            view,
            allocations
        )
        assert(view != {}, "Swapchain View is not nil!")
    }
    delete(swapchain.views)

    log.debug("Destroying Swapchain Images")
    delete(swapchain.images)
    
    log.debug("Destroying Swapchain")
    vk.DestroySwapchainKHR(
        logical.device,
        swapchain.swapchain,
        allocations
    )
    assert(swapchain.swapchain != {}, "Swapchain is not nil!")

    return
}
