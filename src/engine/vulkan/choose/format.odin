package vk_choose

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"

HasStencil :: proc(format: vk.Format) -> bool {
    has := (format == .D32_SFLOAT_S8_UINT) || (format == .D24_UNORM_S8_UINT)
    log.debug("HasStencil: ", "True" if has else "False")
    return has
}

FindSupportedFormat :: proc(
    data: ^t.VulkanData             = nil,
    candidates: []vk.Format         = {},
    tiling: vk.ImageTiling          = .OPTIMAL,
    features: vk.FormatFeatureFlags = {},
) -> (supportedFormat: vk.Format, ok: bool = true) #optional_ok {

    for &format in candidates {
        formatProperties: vk.FormatProperties

        vk.GetPhysicalDeviceFormatProperties(
            data.physical.device,
            format,
            &formatProperties
        )

        if tiling == .LINEAR && (formatProperties.linearTilingFeatures & features) == features {
            supportedFormat = format
            return
        }

        if tiling == .OPTIMAL && (formatProperties.optimalTilingFeatures & features) == features {
            supportedFormat = format
            return
        }
    }

    panic("Faield to find supported format!")
}