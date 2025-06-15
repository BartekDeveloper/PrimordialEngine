package vk_create

import "core:log"
import "core:mem"
import "core:c"
import "core:os"
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

    for i := 0; i < int(render.MAX_FRAMES_IN_FLIGHT); i += 1 { 
        using syncObjects

        semaphores[i].createInfo = {
            sType = .SEMAPHORE_CREATE_INFO,
            pNext = nil,
            flags = {},
        }
        fences[i].createInfo = {
            sType = .FENCE_CREATE_INFO,
            pNext = nil,
            flags = {},
        }
        
        result := vk.CreateSemaphore(
            logical.device,
            &semaphores[i].createInfo,
            nil,
            &semaphores[i].image
        )
        if result != .SUCCESS {
            log.panic("Failed to create semaphore!")
        }

        result = vk.CreateSemaphore(
            logical.device,
            &semaphores[i].createInfo,
            nil,
            &semaphores[i].render
        )
        if result != .SUCCESS {
            log.panic("Failed to create semaphore!")
        }

        result = vk.CreateFence(
            logical.device,
            &fences[i].createInfo,
            nil,
            &fences[i].this
        )
        if result != .SUCCESS {
            log.panic("Failed to create fence!")
        }
    }

    return
}