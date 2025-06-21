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

SyncObjects :: proc(
    data: ^t.VulkanData = nil
) -> () {

    log.debug("Destroying Sync Objects")

    for &sync in data.syncObjects.semaphores {
        vk.DestroySemaphore(
            data.logical.device,
            sync.image,
            data.allocations
        )
        vk.DestroySemaphore(
            data.logical.device,
            sync.render,
            data.allocations
        )
    }

    for &sync in data.syncObjects.fences {
        vk.DestroyFence(
            data.logical.device,
            sync.this,
            data.allocations
        )
    }

    return
}
