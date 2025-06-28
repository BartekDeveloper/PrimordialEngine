package vk_object

import "core:mem/virtual"
import "core:text/regex/virtual_machine"
import "core:fmt"
import "core:mem"
import "core:strings"

import vk "vendor:vulkan"

import "../choose"
import "../create"
import "../destroy"
import "../copy"
import t "../types"
import obj "../../objects"
import emath "../../../maths"
import s "../../../shared"

data: ^t.VulkanData = nil
SetDataPointer   :: proc(pData: ^t.VulkanData) { data = pData }
UnSetDataPointer :: proc()                     { data = nil }

VkDataBuffer :: struct {
    vertex:     t.Buffer,
    index:      t.Buffer,

    vertexCount: u32,
    indexCount:  u32,

    hasIndices: bool,
}

buffers: map[string]map[string]VkDataBuffer = {}

CreateBuffersForModel :: proc(
    name: string = "",
) {
    if name == "" || name == " " || strings.is_null(auto_cast name[0]) {
        fmt.eprintln("[WARN] CreateBuffersForModel: Model name is empty!")
        return
    }

    if data == nil {
        fmt.eprintln("[ERROR] CreateBuffersForModel: VulkanData pointer is nil! Call SetDataPointer first.")
        return
    }
    
    sceneData, ok := obj.GetModel(name)
    if !ok {
        fmt.eprintfln("[ERROR] CreateBuffersForModel: Model '%s' not found!", name)
        return
    }
    
    fmt.eprintfln("Creating Vulkan buffers for model '%s'...", name)
    
    if _, exists := buffers[name]; !exists {
        buffers[name] = make(map[string]VkDataBuffer)
    }

    buffers[name] = {}
    currentBufferGroup := &buffers[name]
    // For model
    for modelKey, &model in sceneData.objects {
        // For mesh
        for meshName, &mesh in model.meshes {
            
            currentBufferGroup[meshName] = {}
            meshBuffers := &currentBufferGroup[meshName]
            meshBuffers.vertexCount = u32(len(mesh.vertices))
            meshBuffers.indexCount  = u32(len(mesh.indices))

            if meshBuffers == nil {
                panic("Trying to make `vulkan` object buffers `meshBuffers`` is nil!")
            }

            if len(mesh.vertices) > 0 {
                vertexBufferSize := vk.DeviceSize(len(mesh.vertices) * size_of(s.Vertex))

                meshBuffers.vertex        = {}
                meshBuffers.vertex.offset = 0
                meshBuffers.vertex.this   = {}
                meshBuffers.vertex.ptr    = nil

                newVertexBuffer := &meshBuffers.vertex
                good := create.Buffer_modify(
                    data,
                    newVertexBuffer,
                    vertexBufferSize,
                    { .VERTEX_BUFFER },
                    { .HOST_VISIBLE, .HOST_COHERENT },
                )
                if !good {
                    fmt.eprintfln("[ERROR] Failed to create vertex buffer for model '%s' (scene: %s), mesh '%s'", modelKey, name, meshName)
                    continue
                }
                
                copy.ToBuffer(
                    data,
                    newVertexBuffer,
                    raw_data(mesh.vertices),
                    vertexBufferSize,
                )
            }
            
            meshBuffers.hasIndices = false
            if len(mesh.indices) > 0 {
                indexBufferSize := vk.DeviceSize(len(mesh.indices) * size_of(u32))
                
                meshBuffers.index = {}
                newIndexBuffer := &meshBuffers.index
                good := create.Buffer_modify(
                    data,
                    newIndexBuffer,
                    indexBufferSize,
                    { .INDEX_BUFFER },
                    { .HOST_VISIBLE, .HOST_COHERENT },
                )
                if !good {
                    fmt.eprintfln("[ERROR] Failed to create index buffer for model '%s' (scene: %s), mesh '%s'", modelKey, name, meshName)
                    continue
                }
                
                copy.ToBuffer(
                    data,
                    newIndexBuffer,
                    raw_data(mesh.indices),
                    indexBufferSize,
                )
                meshBuffers.hasIndices = true
            }
        }
    }
    fmt.eprintfln("Finished creating Vulkan buffers for model '%s'.", name)
}

CreateBuffersForAllModels :: proc() -> () {
    if data == nil {
        fmt.eprintln("[ERROR] CreateBuffersForAllModels: VulkanData pointer is nil! Call SetDataPointer first.")
        return
    }
    
    modelNames := obj.ListModelNames()
    defer delete(modelNames)

    if len(modelNames) == 0 {
        fmt.eprintln("No models loaded in objects package to create buffers for.")
        return
    }
    fmt.eprintln("Creating Vulkan buffers for all loaded models...")
    
    for name in modelNames {
        CreateBuffersForModel(name)
    }
    fmt.eprintln("Finished creating Vulkan buffers for all loaded models.")

    return
}

CleanUpBuffersForModel :: proc(name: string) {
    if data == nil {
        fmt.eprintln("[ERROR] CleanUpBuffersForModel: VulkanData pointer is nil! Call SetDataPointer first.")
        return
    }
    
    sceneData, ok := obj.GetModel(name)
    if !ok {
        fmt.eprintfln("[ERROR] CreateBuffersForModel: Model '%s' not found!", name)
        return
    }
    fmt.eprintfln("Creating Vulkan buffers for model '%s'...", name)

    buffers[name] = {}
    currentBufferGroup := &buffers[name]

    // For model
    for modelKey, &model in sceneData.objects {
        // For mesh
        for meshName, &mesh in model.meshes {
            
            currentBufferGroup[meshName] = {}
            meshBuffers := &currentBufferGroup[meshName]

            destroy.Buffer(data, &meshBuffers.vertex)
            destroy.Buffer(data, &meshBuffers.index)            
        }
        delete(model.meshes)
    }
    delete(sceneData.objects)
}

CleanUpAllBuffers :: proc() -> () {
    if data == nil {
        panic("[ERROR] CleanUpAllBuffers: VulkanData pointer is nil! Call SetDataPointer first.")
    }

    for modelGroupName, &buffer in buffers {
        for meshName, &meshBuffers in buffer {
            destroy.Buffer(data, &meshBuffers.vertex)
            destroy.Buffer(data, &meshBuffers.index)
        }
        delete(buffer)
    }
    delete(buffers)
    return
}

VkDrawAllMeshes :: proc(
    cmd: ^vk.CommandBuffer = nil,
    name: string           = ""
) -> () {
    if _, exists := buffers[name]; !exists {
        fmt.eprintfln("[ERROR] VkDraw: No buffers found for model '%s'", name)
        return
    }

    modelBuffers := buffers[name]
    offsets: []vk.DeviceSize = { 0 }

    for meshName, &meshBuffer in modelBuffers {
        // Bind vertex buffer
        vertexBuffers: []vk.Buffer = { meshBuffer.vertex.this }

        
        vk.CmdBindVertexBuffers(
            cmd^,
            0,
            meshBuffer.vertexCount,
            raw_data(vertexBuffers),
            raw_data(offsets)
        )
        
        if meshBuffer.hasIndices {
            vk.CmdBindIndexBuffer(cmd^, meshBuffer.index.this, 0, .UINT32)
            vk.CmdDrawIndexed(cmd^, meshBuffer.indexCount, 1, 0, 0, 0)
            
            return
        }

        vk.CmdDraw(cmd^, meshBuffer.vertexCount, 1, 0, 0)
    }
    return
}

VkDrawMesh :: proc(
    cmd: ^vk.CommandBuffer = nil,
    name: string           = "",
    meshName: string       = ""
) -> () {
    if _, exists := buffers[name]; !exists {
        fmt.eprintfln("[ERROR] VkDrawMesh: No buffers found for model '%s'", name)
        return
    }

    modelBuffers := buffers[name]
    meshBuffer   := modelBuffers[meshName]

    offsets:       []vk.DeviceSize = { 0 }
    vertexBuffers: []vk.Buffer = { meshBuffer.vertex.this }

    vk.CmdBindVertexBuffers(
        cmd^,
        0,
        meshBuffer.vertexCount,
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
