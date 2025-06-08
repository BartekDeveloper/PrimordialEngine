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

import t "types"
import "create"

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
        vk.EXT_DEBUG_UTILS_EXTENSION_NAME
    }
    
    create.AppInfo(data)
    
    log.assert(vk.CreateInstance != nil)
    create.Instance(data)
   
    log.info("Vulkan reading instance addresses")
    vk.load_proc_addresses(data.instance.instance)

    create.Surface(data)
}

