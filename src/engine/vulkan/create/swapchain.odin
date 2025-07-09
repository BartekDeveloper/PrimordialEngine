package vk_create

import "core:log"
import "core:c"

import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import "../choose"
import t   "../types"
import win "../../window"

Swapchain :: proc(data: ^t.VulkanData) -> () {
    using data

    swapchain.formats.depth = choose.SwapchainDepthFormat(data)

    log.debug("Swapchain data initializing")
    swapchain.extent          = choose.SwapchainExtent(data)
    swapchain.formats.surface = choose.SwapchainFormat(data)
    swapchain.presentMode     = choose.SwapchainPresentMode(data)
    log.infof("Present Mode: %s", swapchain.presentMode)
    log.infof("Surface Format: %s\t%s", swapchain.formats.surface.colorSpace, swapchain.formats.surface.format)
    log.infof("Extent: %d x %d", swapchain.extent.width, swapchain.extent.height)

    log.debug("Getting swapchain image count")
    swapchain.imageCount = physical.capabilities.minImageCount + 1
    if swapchain.imageCount > physical.capabilities.maxImageCount {
        swapchain.imageCount = physical.capabilities.maxImageCount
    }
    if swapchain.imageCount == 0 {
        panic("Swapchain max image count is equal to 0!")
    }
    log.infof("Swapchain image count: %d", swapchain.imageCount)


    log.debug("Swapchain Create Info")
    preTransform := physical.capabilities.currentTransform
    indices: []u32 = { physical.queues.idx.present, physical.queues.idx.graphics }

    swapchain.createInfo = {
        sType                 = .SWAPCHAIN_CREATE_INFO_KHR,
        surface               = surface,
        minImageCount         = swapchain.imageCount,
        imageFormat           = swapchain.formats.surface.format,
        imageColorSpace       = swapchain.formats.surface.colorSpace,
        imageExtent           = swapchain.extent,
        imageArrayLayers      = 1,
        imageUsage            = { .COLOR_ATTACHMENT },
        imageSharingMode      = .EXCLUSIVE,
        queueFamilyIndexCount = 0,
        pQueueFamilyIndices   = nil,
        preTransform          = preTransform,
        compositeAlpha        = { .OPAQUE },
        presentMode           = swapchain.presentMode,
        clipped               = true,
    }
    if indices[0] != indices[1] {
        swapchain.createInfo.imageSharingMode = .CONCURRENT
        swapchain.createInfo.queueFamilyIndexCount = u32(len(indices))
        swapchain.createInfo.pQueueFamilyIndices   = raw_data(indices)
    } else {
        swapchain.createInfo.imageSharingMode = .EXCLUSIVE
    }

    log.debug("Creating Swapchain")
    result := vk.CreateSwapchainKHR(logical.device, &swapchain.createInfo, allocations, &swapchain.swapchain)
    if result != .SUCCESS {
        log.error("Failed to create swapchain!")
    }
    log.debug("Swapchain created!")

    SwapchainImages(data)
    return
}

SwapchainImages :: proc(data: ^t.VulkanData) -> () {
    using data

    good: bool = true

    log.debug("Requesting swapchain images")
    swapchain.images = make([dynamic]vk.Image,     swapchain.imageCount)
    vk.GetSwapchainImagesKHR(logical.device, swapchain.swapchain, &swapchain.imageCount, raw_data(swapchain.images))
    if len(swapchain.images) == 0 {
        panic("Failed to get swapchain images!")
    }
    Label_mutliple_2(
        logical.device,
        "Swapchain Image",
        ([^]u64)(raw_data(swapchain.images)),
        u32(len(swapchain.images)),
        .IMAGE
    )

    log.debug("Creating swapchain image views")
    swapchain.views = make([dynamic]vk.ImageView, len(swapchain.images))
    for &view, i in swapchain.views  {
        view, good = ImageView(
            data,
            swapchain.images[i],
            swapchain.formats.surface.format
        )
        if !good {
            panic("Failed to create Swapchain Views!")
        }
    }
    Label_mutliple_2(
        logical.device,
        "Swapchain Image View", 
        ([^]u64)(raw_data(swapchain.views)),
        u32(len(swapchain.views)),
        .IMAGE_VIEW
    )

    i: int = 0 
    for &view in swapchain.views {
        log.assertf(view != {}, "Swapchain View #%d is nil!", i)
        i += 1
    }

    return
}