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

InitFromZero :: proc(data: ^t.VulkanData) {
    using data;
    
    // vk.load_proc_addresses(win.ProcAddr)

    instance.layers = {
        "VK_LAYER_KHRONOS_validation"
    }

    instance.extensions = {
        vk.EXT_DEBUG_UTILS_EXTENSION_NAME
    }
    
    create.AppInfo(data)
    create.Instance(data)
    
    // vk.load_proc_addresses(data.instance.instance)

    create.Surface(data)
}

