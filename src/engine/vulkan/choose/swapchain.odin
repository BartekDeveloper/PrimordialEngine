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

SwapchainExtent :: proc(data: ^t.VulkanData) -> (extent: vk.Extent2D = {}) {
    using data;

    width, height := win.GetFrameBufferSize()

    extent.width  = width
    extent.height = height

    return
}

SwapchainFormat :: proc(data: ^t.VulkanData) -> (surfaceFormat: vk.SurfaceFormatKHR) {
    using data;
    surfaceFormat = { colorSpace = .SRGB_NONLINEAR, format = .UNDEFINED }

    wanted: []vk.SurfaceFormatKHR = {
        { .B8G8R8A8_UNORM, .SRGB_NONLINEAR },
        { .B8G8R8A8_SRGB,  .SRGB_NONLINEAR },
    }

    formatsCount: u32 = 0
    result := vk.GetPhysicalDeviceSurfaceFormatsKHR(
        physical.device,
        surface,
        &formatsCount,
        nil
    )
    if result != .SUCCESS {
        log.panic("Failed to get physical device surface formats!")
    }

    swapchainFormats: []vk.SurfaceFormatKHR
    swapchainFormats = make([]vk.SurfaceFormatKHR, formatsCount)
    result = vk.GetPhysicalDeviceSurfaceFormatsKHR(
        physical.device,
        surface,
        &formatsCount,
        raw_data(swapchainFormats)
    )
    if result != .SUCCESS {
        log.panic("Failed to get physical device surface formats!")
    }

    fmt.eprintfln("=*=*=*= Wanted Formats =*=*=*=")
    for &f in wanted {
        fmt.eprintfln("\t%s\t%s", f.colorSpace, f.format)
    }
    fmt.eprintfln("=*=*=*= Wanted Formats =*=*=*=")
    fmt.eprintln("")
    fmt.eprintfln("=*=*=*= Found Formats =*=*=*=")
    for &f in swapchainFormats {
        fmt.eprintfln("\t%s\t%s", f.colorSpace, f.format)
    }
    fmt.eprintfln("=*=*=*= Found Formats =*=*=*=")

    formatsScores: map[vk.SurfaceFormatKHR]int = {}
    for w, i in wanted {
        for a, _ in swapchainFormats {
            if a == w {
                score := int(len(swapchainFormats)) + 1 - i
                formatsScores[a] = score
            }
        }
    }

    maxScore: int = -1
    for format, score in formatsScores {
        if score > maxScore {
            maxScore      = score
            surfaceFormat = format
        }
    }

    return
}

SwapchainPresentMode :: proc(data: ^t.VulkanData) -> (presentMode: vk.PresentModeKHR) {
    using data;
    presentMode = .FIFO

    wanted: []vk.PresentModeKHR = {
        .IMMEDIATE,
        .MAILBOX,
        .FIFO_RELAXED,
        .FIFO,
    }
    
    presentModesCount: u32 = 0
    result := vk.GetPhysicalDeviceSurfacePresentModesKHR(
        physical.device,
        surface,
        &presentModesCount,
        nil
    )
    if result != .SUCCESS {
        log.panic("Failed to get physical device surface present modes!")
    }

    presentModes: []vk.PresentModeKHR
    presentModes = make([]vk.PresentModeKHR, presentModesCount)
    result = vk.GetPhysicalDeviceSurfacePresentModesKHR(
        physical.device,
        surface,
        &presentModesCount,
        raw_data(presentModes)
    )
    if result != .SUCCESS {
        log.panic("Failed to get physical device surface present modes!")
    }

    fmt.eprintfln("=*=*=*= Wanted Present Modes =*=*=*=")
    for &m in wanted {
        fmt.eprintfln("\t%s", m)
    }
    fmt.eprintfln("=*=*=*= Wanted Present Modes =*=*=*=")
    fmt.eprintln("")
    fmt.eprintfln("=*=*=*= Found Present Modes =*=*=*=")
    for &m in presentModes {
        fmt.eprintfln("\t%s", m)
    }
    fmt.eprintfln("=*=*=*= Found Present Modes =*=*=*=")

    presentModesScores: map[vk.PresentModeKHR]int = {}
    for w, i in wanted {
        for a, _ in presentModes {
            if a == w {
                score := int(len(presentModes)) + 1 - i
                presentModesScores[a] = score
            }
        }
    }

    maxScore: int = -1
    for mode, score in presentModesScores {
        if score > maxScore {
            maxScore    = score
            presentMode = mode
        }
    }

    return
}

SwapchainDepthFormat :: proc(data: ^t.VulkanData) -> (found: vk.Format = .D32_SFLOAT_S8_UINT, good: bool = true) #optional_ok {
    using data; 

    log.debug("Getting depth format")
    depthFormats: []vk.Format = { .D32_SFLOAT_S8_UINT, .D24_UNORM_S8_UINT, .D32_SFLOAT }

    found, good = FindSupportedFormat(
        data,
        depthFormats,
        .OPTIMAL,
        { .DEPTH_STENCIL_ATTACHMENT }
    )
    if !good {
        log.fatal("Failed to find suitable depth format!")
    }

    log.debugf("Found depth format: %s", found)

    return
}


