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

SyncObjects :: proc(
    data: ^t.VulkanData = nil
) -> () {
    log.debug("Destroying Sync Objects")

    for &sem in data.syncObjects.semaphores {
        vk.DestroySemaphore(
            data.logical.device,
            sem.image,
            data.allocations
        )
        vk.DestroySemaphore(
            data.logical.device,
            sem.render,
            data.allocations
        )
    }
    delete(data.syncObjects.semaphores)

    for &fence in data.syncObjects.fences {
        vk.DestroyFence(
            data.logical.device,
            fence.this,
            data.allocations
        )
    }
    delete(data.syncObjects.fences)

    return
}
