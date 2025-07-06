package vk_create

import "core:log"
import "core:c"

import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import "../choose"
import t "../types"
import win "../../window"

@(require_results)
Image_return :: proc(
    data: ^t.VulkanData                      = nil,
    width: u32                               = 0,
    height: u32                              = 0,
    memory: ^vk.DeviceMemory                 = nil,
    memoryProperties: vk.MemoryPropertyFlags = { .HOST_VISIBLE, .HOST_COHERENT },
    format: vk.Format                        = .R8G8B8A8_SINT,
    usage: vk.ImageUsageFlags                = { .COLOR_ATTACHMENT },
    mipLevels:  u8                           = 1,
    arrayLayers: u16                         = 1,
    imageType: vk.ImageType                  = .D2,
    tiling: vk.ImageTiling                   = .OPTIMAL,
    initialLayout: vk.ImageLayout            = .UNDEFINED,
    flags: vk.ImageCreateFlags               = {},
    msaaSamples: vk.SampleCountFlags         = { ._1 },
    depth: u32                               = 1,

) -> (image: vk.Image, good: bool = true) #optional_ok {
    imageCreateInfo: vk.ImageCreateInfo = {
        sType           = .IMAGE_CREATE_INFO,
        imageType       = imageType,
        format          = format,
        extent          = { width, height, depth },
        mipLevels       = (u32)(mipLevels),
        arrayLayers     = (u32)(arrayLayers),
        samples         = msaaSamples,
        tiling          = tiling,
        usage           = usage,
        sharingMode     = .EXCLUSIVE,
        initialLayout   = initialLayout,
        flags           = {},
    }
    
    result := vk.CreateImage(data.logical.device, &imageCreateInfo, data.allocations, &image)
    if result != .SUCCESS {
        good = false
        log.error("Failed to create image!")
    }

    memoryRequirements: vk.MemoryRequirements
    vk.GetImageMemoryRequirements(data.logical.device, image, &memoryRequirements)

    memType: u32  = 0
    good = choose.MemoryType(data.physical.device, memoryRequirements.memoryTypeBits, memoryProperties, &memType)
    if !good {
        panic("Failed to find suitable memory type!")
    }

    memoryAllocateInfo: vk.MemoryAllocateInfo
    memoryAllocateInfo = {
        sType           = .MEMORY_ALLOCATE_INFO,
        allocationSize  = memoryRequirements.size,
        memoryTypeIndex = memType,
    }

    result = vk.AllocateMemory(data.logical.device, &memoryAllocateInfo, data.allocations, memory)
    if result != .SUCCESS {
        good = false
        log.error("Failed to allocate memory!")
    }

    result = vk.BindImageMemory(data.logical.device, image, memory^, 0)
    if result != .SUCCESS {
        good = false
        log.error("Failed to bind image memory!")
    }

    return
}

Image_modify :: proc(
    data: ^t.VulkanData                      = nil,
    image: ^vk.Image                         = nil,
    width: u32                               = 0,
    height: u32                              = 0,
    memory: ^vk.DeviceMemory                 = nil,
    memoryProperties: vk.MemoryPropertyFlags = { .HOST_VISIBLE, .HOST_COHERENT },
    format: vk.Format                        = vk.Format.R8G8B8A8_SINT,
    usage: vk.ImageUsageFlags                = { .COLOR_ATTACHMENT },
    mipLevels:  u8                           = 1,
    arrayLayers: u16                         = 1,
    imageType: vk.ImageType                  = .D2,
    tiling: vk.ImageTiling                   = .OPTIMAL,
    initialLayout: vk.ImageLayout            = .UNDEFINED,
    flags: vk.ImageCreateFlags               = {},
    msaaSamples: vk.SampleCountFlags         = { ._1 },
    depth: u32                               = 1,
) -> (good: bool = true) {

    image^, good = Image_return(
        data,
        width,
        height,
        memory,
        memoryProperties,
        format,
        usage,
        mipLevels,
        arrayLayers,
        imageType,
        tiling,
        initialLayout,
        flags,
        msaaSamples,
        depth
    )
    return
}

Image :: proc{
    Image_modify,
    Image_return,
}