#+feature dynamic-literals
package vulkan_renderer

import "core:log"
import "core:mem"
import "core:c"
import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import th "core:thread"
import vk "vendor:vulkan"

import "load"
import "create"
import t "types"
import win "../window"

InitFromZero :: proc(data: ^t.VulkanData, loc := #caller_location) {
    using data;

    log.infof("%s", loc)
    log.info("Initializing from zero")
    
    log.info("Vulkan reading addr")
    vk.load_proc_addresses(rawptr(win.ProcAddr()))

    log.info("Setting up layers and extensions")
    instance.layers = {
        "VK_LAYER_KHRONOS_validation"
    }
    instance.extensions = {
        vk.EXT_DEBUG_UTILS_EXTENSION_NAME,
        vk.KHR_GET_SURFACE_CAPABILITIES_2_EXTENSION_NAME
    }    
    logical.extensions = {
        vk.KHR_SWAPCHAIN_EXTENSION_NAME
    }
    logical.requestedFeatures = {
        samplerAnisotropy = true
    }

    load.SetVulkanDataPointer(data)
    defer load.RemoveVulkanDataPointer()

    create.AppInfo(data) 
    create.Instance(data)
    create.Surface(data)
    create.PhysicalDeviceData(data)
    create.LogicalDevice(data)
    create.Swapchain(data)
    create.RenderPasses(data)
    create.DescriptorSetLayouts(data)
    load.Shaders()
    create.Pipelines(data)
    create.Resources(data)
    create.Framebuffers(data)
}

