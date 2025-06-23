package vk_create

import "core:log"
import "core:c"

import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"

ImageView_return :: proc(
    data: ^t.VulkanData             = nil,
    image: vk.Image                 = 0,
    format: vk.Format               = vk.Format.R8G8B8A8_SINT,
    aspectMask: vk.ImageAspectFlags = { .COLOR },
    mipLevels:  u8                  = 1,
    arrayLayers: u16                = 1,
    tiling: vk.ImageTiling          = .OPTIMAL,
    baseMipLevel: u8                = 0,
    baseArrayLayer: u8              = 0,
    components: vk.ComponentMapping = { .R, .G, .B, .A },
    viewType: vk.ImageViewType      = .D2,
    flags: vk.ImageViewCreateFlags  = {},
) -> (imageView: vk.ImageView, good: bool = true) #optional_ok {

    viewCreateInfo: vk.ImageViewCreateInfo = {
        sType           = .IMAGE_VIEW_CREATE_INFO,
        image           = image,
        viewType        = viewType,
        format          = format,
        components      = components,
        subresourceRange = {
            aspectMask     = aspectMask,
            baseMipLevel   = (u32)(baseMipLevel),
            levelCount     = (u32)(mipLevels),
            baseArrayLayer = (u32)(baseArrayLayer),
            layerCount     = (u32)(arrayLayers),
        },
        flags = flags
    }
    
    result := vk.CreateImageView(data.logical.device, &viewCreateInfo, data.allocations, &imageView)
    if result != .SUCCESS {
        log.error("Failed to create image view!")
        good = false
    }

    return
}

ImageView_modify :: proc(
    data: ^t.VulkanData             = nil,
    imageView: ^vk.ImageView        = nil,
    image: vk.Image                 = 0,
    format: vk.Format               = vk.Format.R8G8B8A8_SINT,
    aspectMask: vk.ImageAspectFlags = { .COLOR },
    mipLevels:  u8                  = 1,
    arrayLayers: u16                = 1,
    tiling: vk.ImageTiling          = .OPTIMAL,
    baseMipLevel: u8                = 0,
    baseArrayLayer: u8              = 0,
    components: vk.ComponentMapping = { .R, .G, .B, .A },
    viewType: vk.ImageViewType      = .D2,
    flags: vk.ImageViewCreateFlags  = {},
) -> (good: bool = true) {

    imageView^, good = ImageView_return(
        data,
        image,
        format,
        aspectMask,
        mipLevels,
        arrayLayers,
        tiling,
        baseMipLevel,
        baseArrayLayer,
        components,
        viewType,
        flags
    )
    return
}

ImageView :: proc{
    ImageView_modify,
    ImageView_return,
}
