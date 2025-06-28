package vulkan_renderer

import "core:log"
import "core:c"

import "core:fmt"
import "core:strings"
import "core:strconv"
import th "core:thread"
import vk "vendor:vulkan"

import "destroy"
import "load"
import t "types"
import o "objects"
import "../window"
import vk_obj "../objects"
import s "../../shared"
import emath "../../maths"

Clean :: proc(data: ^s.RenderData) {
    using data

    fmt.eprintln("Cleaning up Vulkan data...")

    o.SetDataPointer(&vkData)
    defer o.UnSetDataPointer()
    o.CleanUpAllBuffers()

    load.SetVulkanDataPointer(&vkData)
    defer load.UnSetVulkanDataPointer()

    //? Vulkan Data Cleaning functions
    destroy.AdditionalData(&vkData)
    destroy.SyncObjects(&vkData)
    destroy.Samplers(&vkData)
    destroy.DescriptorPools(&vkData)
    destroy.UniformBuffers(&vkData)
    destroy.CommandPools(&vkData)
    destroy.CommandBuffers(&vkData)
    destroy.FrameBuffers(&vkData)
    destroy.Pipelines(&vkData)
    destroy.Descriptors(&vkData)
    destroy.RenderPasses(&vkData)    
    destroy.Swapchain(&vkData)
    load.CleanUpShaderModules()
    destroy.LogicalDevice(&vkData)
    destroy.PhysicalDeviceData(&vkData)
    destroy.Surface(&vkData)
    destroy.Instance(&vkData)
    destroy.AppInfo(&vkData)

    // Loaded Vulkan Data Cleaning functions

    //* Now LETS SET ALL OF THE DATA(Vulkan Data) free
    //* and then set them to nil pointers
    //? ... End of vulkan deinitialization
    
    //! Engine DeInit in other file!

    fmt.eprintln("Finished cleaning up Vulkan data!")

    return
}