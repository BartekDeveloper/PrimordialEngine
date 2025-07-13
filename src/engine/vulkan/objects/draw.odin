package vk_object

import "core:fmt"
import vk "vendor:vulkan"

import t "../types"
import e "../../entity"
import s "../../../shared"
import em "../../../maths"

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

VkDrawMeshes :: proc(
    cmd: ^vk.CommandBuffer = nil,
    name: string           = "",
) -> () {
    // fmt.eprintfln("[DEBUG] VkDrawMeshes called with name='%s'", name)
    // fmt.eprintfln("[DEBUG] Buffers map content inside VkDrawMeshes: %v", buffers)

    modelBuffers, modelExists := buffers[name]
    if !modelExists {
        fmt.eprintfln("[ERROR] VkDrawMeshes: No buffer sets found for model '%s'", name)
        return
    }

    for meshName, meshBuffer in modelBuffers {
        VkDrawMesh(cmd, name, meshName)
    }
    return
}

VkDrawMeshWithPushData :: proc(
    cmd: ^vk.CommandBuffer = nil,
    name: string           = "",
    meshName: string       = "",
    pushData: s.PushData   = {},
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

    geometryPipeline := &data.pipelines["geometry"]

    vk.CmdPushConstants(
        cmd^,
        geometryPipeline.layout,
        { .VERTEX },
        0,
        pushData.size,
        pushData.data,
    )

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

VkDrawMeshesWithPushData :: proc(
    cmd: ^vk.CommandBuffer = nil,
    name: string           = "",
    pushData: s.PushData   = {},
) -> () {
    // fmt.eprintfln("[DEBUG] VkDrawMeshes called with name='%s'", name)
    // fmt.eprintfln("[DEBUG] Buffers map content inside VkDrawMeshes: %v", buffers)

    modelBuffers, modelExists := buffers[name]
    if !modelExists {
        fmt.eprintfln("[ERROR] VkDrawMeshes: No buffer sets found for model '%s'", name)
        return
    }

    for meshName, meshBuffer in modelBuffers {
        VkDrawMeshWithPushData(cmd, name, meshName, pushData)
    }
    return
}

VkDrawMeshesWithPushDatas :: proc(
    cmd: ^vk.CommandBuffer  = nil,
    name: string            = "",
    pushDatas: []s.PushData = {},
) -> () {
    // fmt.eprintfln("[DEBUG] VkDrawMeshes called with name='%s'", name)
    // fmt.eprintfln("[DEBUG] Buffers map content inside VkDrawMeshes: %v", buffers)

    modelBuffers, modelExists := buffers[name]
    if !modelExists {
        fmt.eprintfln("[ERROR] VkDrawMeshes: No buffer sets found for model '%s'", name)
        return
    }

    i: int = 0
    for meshName, meshBuffer in modelBuffers {
        VkDrawMeshWithPushData(cmd, name, meshName, pushDatas[i])
        i += 1
    }
    
    return
}

DrawEntity :: proc(entity: ^e.Entity, cmd: ^vk.CommandBuffer) -> () {
    using entity
    
    if modelName == "" {
        fmt.eprintfln("[ERROR] DrawEntity: Model name is empty!")
        return
    }

    modelMat := e.GetModelMatrix(entity)
    fmt.eprintfln("[DEBUG] modelMat: %v", modelMat)

    data: []any = { modelMat }
    
    pushData: s.PushData = {} 
    pushData.size = size_of(em.Mat4)
    pushData.data = raw_data(data)

    VkDrawMeshesWithPushData(
        cmd,
        modelName,
        pushData
    )

    return
}