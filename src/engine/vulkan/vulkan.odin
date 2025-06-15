package vulkan_renderer

import "core:log"
import s "../../shared"

import "../window"
import t "types"

vkData: t.VulkanData = {}

Init :: proc(rData: ^s.RenderData) {

    InitFromZero(&vkData, rData)  
    return
}

Render :: proc(data: ^s.RenderData) {
    return
}

Wait :: proc() {
    return
}

Clean :: proc(data: ^s.RenderData) {
    return
}


