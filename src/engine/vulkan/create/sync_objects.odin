package vk_create

import "core:sync"
import "core:log"
import "core:mem"
import "core:c"

import "core:fmt"
import "core:strings"
import "core:strconv"
import th "core:thread"
import vk "vendor:vulkan"

import t "../types"
import s "../../../shared"

SyncObjects :: proc(data: ^t.VulkanData, render: ^s.RenderData) {
    using data
    log.info("Creating sync objects")
    
    log.assert(render != nil, "Render data is nil, provide a correct render data struct")
    log.assert(data   != nil, "Vulkan Data is nil, provide a correct vulkan data struct")
    
    syncObjects.semaphores = make([]t.SemaphoresObjects, data.swapchain.imageCount)
    for &sem, i in syncObjects.semaphores { 
        using syncObjects

        semaphores[i].createInfo = {    
            sType = .SEMAPHORE_CREATE_INFO,
            pNext = nil,
            flags =  {},
        }
        
        result := vk.CreateSemaphore(
            logical.device,
            &semaphores[i].createInfo,
            allocations,
            &semaphores[i].image
        )
        if result != .SUCCESS {
            panic("Failed to create semaphore!")
        }

        result = vk.CreateSemaphore(
            logical.device,
            &semaphores[i].createInfo,
            allocations,
            &semaphores[i].render
        )
        if result != .SUCCESS {
            panic("Failed to create semaphore!")
        }

    }

    syncObjects.fences     = make([]t.FenceObject, data.renderData.MAX_FRAMES_IN_FLIGHT)
    for &fence, i in syncObjects.fences {
        using syncObjects

        fence.createInfo = {
            sType = .FENCE_CREATE_INFO,
            pNext = nil,
            flags = { .SIGNALED },
        }

        result := vk.CreateFence(
            logical.device,
            &fence.createInfo,
            allocations,
            &fence.this
        )
        if result != .SUCCESS {
            panic("Failed to create fence!")
        }
    }

    return
}
