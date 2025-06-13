package vk_create

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"

SwapchainImages :: proc(data: ^t.VulkanData) -> () {
    ctx = context
    using data;

    log.debug("Getting swapchain image count")
    swapchain.imageCount = physical.capabilities.minImageCount + 1
    if swapchain.imageCount > physical.capabilities.maxImageCount {
        swapchain.imageCount = physical.capabilities.maxImageCount
    }
    if swapchain.imageCount == 0 {
        log.panic("Swapchain max image count is equal to 0!")
    }
    log.infof("Swapchain image count: %d", swapchain.imageCount)

    log.debug("Requesting swapchain images")
    swapchain.images = make([dynamic]vk.Image,     swapchain.imageCount, allocator=context.temp_allocator)
    vk.GetSwapchainImagesKHR(logical.device, swapchain.swapchain, &swapchain.imageCount, raw_data(swapchain.images))

    log.debug("Creating swpachain image views")
    swapchain.views  = make([dynamic]vk.ImageView, swapchain.imageCount, allocator=context.temp_allocator)
    for &img, i in swapchain.images {
        good: bool = true
        swapchain.views[i], good = ImageView(logical.device, img, data.swapchain.formats.surface)
        if !good {
            log.error("Failed to create Swapchain Views!")
        }
    }

    i: int = 0
    for &view in swapchain.views {
        // Add label here <- . ->
        i += 1
    }

    return
}

Swapchain :: proc(data: ^t.VulkanData) -> () {
    using data;

    SwapchainImages(data)
    ctx = context

    preTransform := physical.capabilities.currentTransform

    log.debug("Swapchain Create Info")
    swapchain.createInfo = {
        sType                 = .SWAPCHAIN_CREATE_INFO_KHR,
        surface               = surface,
        minImageCount         = swapchain.imageCount,
        imageFormat           = swapchain.formats.surface.format,
        imageColorSpace       = swapchain.formats.surface.colorSpace,
        imageExtent           = swapchain.extent,
        imageArrayLayers      = 1,
        imageUsage            = { .COLOR_ATTACHMENT, .TRANSIENT_ATTACHMENT },
        imageSharingMode      = .EXCLUSIVE,
        queueFamilyIndexCount = 0,
        pQueueFamilyIndices   = nil,
        preTransform          = preTransform,
        compositeAlpha        = { .OPAQUE },
        presentMode           = swapchain.presentMode,
        clipped               = true,
    }

    return
}
