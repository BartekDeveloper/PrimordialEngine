package vk_create

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
    using data;
    log.info("Creating sync objects")
    
    log.assert(render != nil, "Render data is nil, provide a correct render data struct")
    log.assert(data   != nil, "Vulkan Data is nil, provide a correct vulkan data struct")
    
    syncObjects.semaphores = make([]t.SemaphoresObjects, swapchain.imageCount)
    syncObjects.fences     = make([]t.FenceObject,       swapchain.imageCount)

    for i := 0; i < int(swapchain.imageCount); i += 1 { 
        using syncObjects

        semaphores[i].createInfo = {    
            sType = .SEMAPHORE_CREATE_INFO,
            pNext = nil,
            flags =  {},
        }

        fences[i].createInfo = {
            sType = .FENCE_CREATE_INFO,
            pNext = nil,
            flags = { .SIGNALED },
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

        result = vk.CreateFence(
            logical.device,
            &fences[i].createInfo,
            allocations,
            &fences[i].this
        )
        if result != .SUCCESS {
            panic("Failed to create fence!")
        }
    }

    return
}
