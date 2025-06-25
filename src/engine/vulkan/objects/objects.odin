package vk_object
import "core:fmt"

import vk "vendor:vulkan"

import t "../types"
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
buffers: map[cstring]map[cstring]VkDataBuffer = {}

VkDraw :: proc(
    cmd: ^vk.CommandBuffer = nil, 
    sceneName: string      = "unnamed",
    modelName: cstring    = "unnamed",
    instances: u32         = 1,
    firstIndex: u32        = 0,
    firstInstance: u32     = 0,
) -> () {
    fmt.eprintfln("Drawing {} of {}", modelName, sceneName)


    scene := scenes[sceneName].meshes[modelName]
    buffer := buffers[sceneName][modelName]

    vertex := buffer.vertex.buffer
    index  := buffer.index.buffer

    vertexCount := u32(len(scene.vertices))
    indexCount  := u32(len(scene.indices))

    vk.CmdBindVertexBuffers(
        cmd,
        0,
        vertexCount,
        vertex,
        0
    )
    if index != nil {
        vk.CmdBindIndexBuffer(
            cmd,
            index,
            0,
            .uint32,
        )

        vk.CmdDrawIndexed(
            cmd,
            indexCount, instances,
            firstIndex, 0, firstInstance
        )
        return
    }
    
    vk.CmdDraw(
        cmd,
        vertexCount, instances,
        firstIndex, firstInstance
    )
    return
}