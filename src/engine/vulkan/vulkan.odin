package vulkan_renderer

import "core:log"
import s "../../shared"

import "../window"
import t "types"

vkData: t.VulkanData = {}

Init :: proc(data: ^s.RenderData) {

    InitFromZero(&vkData)  
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


