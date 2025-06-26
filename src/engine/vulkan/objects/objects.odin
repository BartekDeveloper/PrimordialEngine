package vk_object
import "core:fmt"

import vk "vendor:vulkan"

import t "../types"
import obj "../../objects"
import emath "../../../maths"
import s "../../../shared"

VkDataBuffer :: #type struct {
    vertex: #type struct {
        buffer: ^vk.Buffer,
        offset: vk.DeviceSize,
        size:   vk.DeviceSize,
    },
    
    index: #type struct {
        buffer: ^vk.Buffer,
        offset: vk.DeviceSize,
        size:   vk.DeviceSize,
    },
}
buffers: map[string]map[cstring]VkDataBuffer = {}

VkDraw :: proc(
    cmd: ^vk.CommandBuffer = nil, 
    sceneName: string      = "unnamed",
    modelName: cstring    = "unnamed",
    instances: u32         = 1,
    firstIndex: u32        = 0,
    firstInstance: u32     = 0,
) -> () {
    using obj
    
    fmt.eprintfln("Drawing {} of {}", modelName, sceneName)

    scene := scenes[sceneName].meshes[modelName]
    buffer := buffers[sceneName][modelName]

    vertex := buffer.vertex.buffer
    index  := buffer.index.buffer

    vertexCount := u32(len(scene))
    indexCount  := u32(len(scene))

    vk.CmdBindVertexBuffers(
        cmd^,
        0,
        vertexCount,
        vertex,
        nil
    )
    if index != nil {
        vk.CmdBindIndexBuffer(
            cmd^,
            index^,
            0,
            .UINT32,
        )

        vk.CmdDrawIndexed(
            cmd^,
            indexCount, instances,
            firstIndex, 0, firstInstance
        )
        return
    }
    
    vk.CmdDraw(
        cmd^,
        vertexCount, instances,
        firstIndex, firstInstance
    )
    return
}