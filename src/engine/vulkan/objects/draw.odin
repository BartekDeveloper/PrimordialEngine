package vk_object

import "core:fmt"
import vk "vendor:vulkan"

VkDrawMesh :: proc(
    cmd: ^vk.CommandBuffer = nil,
    name: string           = "",
    meshName: string       = ""
) -> () {
    // fmt.eprintfln("[DEBUG] VkDrawMesh called with name='%s', meshName='%s'", name, meshName)
    // fmt.eprintfln("[DEBUG] Buffers map content inside VkDrawMesh: %v", buffers)

    modelBuffers, modelExists := buffers[name]
    if !modelExists {
        fmt.eprintfln("[ERROR] VkDrawMesh: No buffer sets found for model '%s'", name)
        return
    }

    meshBuffer, meshExits := modelBuffers[meshName]
    if !meshExits {
        fmt.eprintfln("[ERROR] VkDrawMesh: No mesh buffers found for model '%s', mesh '%s'", name, meshName)
        return
    }

    offsets:       []vk.DeviceSize = { 0 }
    vertexBuffers: []vk.Buffer     = { meshBuffer.vertex.this }

    vk.CmdBindVertexBuffers(
        cmd^,
        0,
        u32(len(vertexBuffers)),
        raw_data(vertexBuffers),
        raw_data(offsets)
    )

    if meshBuffer.hasIndices {
        vk.CmdBindIndexBuffer(cmd^, meshBuffer.index.this, 0, .UINT32)
        vk.CmdDrawIndexed(cmd^, meshBuffer.indexCount, 1, 0, 0, 0)
        return
    }

    vk.CmdDraw(cmd^, meshBuffer.vertexCount, 1, 0, 0)
    return
}
