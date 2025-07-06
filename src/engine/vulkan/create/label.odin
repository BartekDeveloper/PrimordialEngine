package vk_create

import "core:log"
import "core:c"
import "core:strings"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"

Label_single :: proc(
    device: vk.Device    = nil,
    what: cstring        = "",
    #any_int handle: u64 = 0, 
    type: vk.ObjectType  = .UNKNOWN,
) -> () {
    when ODIN_DEBUG {
        label: vk.DebugUtilsObjectNameInfoEXT = {
            sType        = .DEBUG_UTILS_LABEL_EXT,
            pNext        = nil,
            pObjectName  = what,
            objectHandle = auto_cast handle,
            objectType   = type,
        }
        res := vk.SetDebugUtilsObjectNameEXT(device, &label)
        if res != .SUCCESS {
            log.errorf("Failed to set label for %s object #%d!", what, handle)
        }
    }
    return
}

Label_mutliple_1 :: proc(
    device: vk.Device    = nil,
    what: cstring        = "",
    handle: []u64        = {}, 
    type: vk.ObjectType  = .UNKNOWN,
) -> () {
    when ODIN_DEBUG {
        for h, i in handle {
            label, err := strings.clone_to_cstring(fmt.tprintf("%s #%d", what, i))
            if err != nil {
                fmt.eprintfln("[ERROR] Failed to make label for %s object #%d!", what, i)
            }
            
            Label_single(
                device,
                label,
                h,
                type
            )
        }
    }
    return
}

Label_mutliple_2 :: proc(
    device: vk.Device    = nil,
    what: cstring        = "",
    handle: [^]u64       = {}, 
    #any_int count: u32  = 0, 
    type: vk.ObjectType  = .UNKNOWN,
) -> () {
    when ODIN_DEBUG {
        for i in 0..<count {
            h := handle[i]

            label, err := strings.clone_to_cstring(fmt.tprintf("%s #%d", what, i))
            if err != nil {
                fmt.eprintfln("[ERROR] Failed to make label for %s object #%d!", what, i)
            }
            defer delete(label)
            
            Label_single(
                device,
                label,
                h,
                type
            )
        }
    }
    return
}

Label_gbuffer :: proc(
    device: vk.Device    = nil,
    what: cstring        = "",
    gbuffer: ^t.GBuffer  = nil
) -> () {
    when ODIN_DEBUG {
        if gbuffer == nil do return

        for img, i in gbuffer.images {
            label, err := strings.clone_to_cstring(fmt.tprintf("%s Image #%d", what, i))
            if err != nil {
                fmt.eprintfln("[ERROR] Failed to make label for %s image #%d!", what, i)
            }
            defer delete(label)
            
            Label_single(
                device,
                label,
                img,
                .IMAGE
            )
        }

        for view, i in gbuffer.views {
            label, err := strings.clone_to_cstring(fmt.tprintf("%s View #%d", what, i))
            if err != nil {
                fmt.eprintfln("[ERROR] Failed to make label for %s image #%d!", what, i)
            }
            defer delete(label)
            
            Label_single(
                device,
                label,
                view,
                .IMAGE_VIEW
            )
        }

        for mem, i in gbuffer.mems {
            label, err := strings.clone_to_cstring(fmt.tprintf("%s Memory #%d", what, i))
            if err != nil {
                fmt.eprintfln("[ERROR] Failed to make label for %s image #%d!", what, i)
            }
            defer delete(label)

            Label_single(
                device,
                label,
                mem,
                .DEVICE_MEMORY
            )
        }
    }
    return
}

Label :: proc{
    Label_single,
    Label_mutliple_1,
    Label_mutliple_2,
    Label_gbuffer,
}