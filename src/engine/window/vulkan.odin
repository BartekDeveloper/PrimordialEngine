package window

import "core:log"
import "core:c"
import "core:fmt"
import "base:runtime"

import sdl "vendor:sdl3"
import vk  "vendor:vulkan"

ProcAddr := sdl.Vulkan_GetVkGetInstanceProcAddr 

VulkanCreateSurface :: proc(
    instance: ^vk.Instance,
    surface: ^vk.SurfaceKHR,
    data: ^WindowData = defaultWindowData,
    allocations: ^vk.AllocationCallbacks = nil
) -> () {
    if !sdl.Vulkan_CreateSurface(
        data.ptr,
        instance^,
        allocations,
        surface
    ) {
        panic("SDL3 Failed to create Vulkan Surface")
    }
    return
}
