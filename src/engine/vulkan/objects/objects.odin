package vk_object

import "base:runtime"
import "core:fmt"
import "core:mem"
import "core:strings"
import rn "base:runtime"

import vk "vendor:vulkan"

import "../choose"
import "../create"
import "../destroy"
import "../copy"
import t "../types"
import utils "../../utils"
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
    if utils.IsReallyEmpty(name) {
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
    
    // THIS IS THE CRITICAL CHANGE: Use context.allocator for persistent map keys
    clonedModelName := strings.clone(name, context.allocator)

    _, exists := buffers[clonedModelName]
    if !exists {
        buffers[clonedModelName] = make(map[string]VkDataBuffer)
    }
    
    currentBufferGroup := &buffers[clonedModelName]

    for modelKey, &model in sceneData.objects {
        for meshName, &mesh in model.meshes {
            clonedMeshName := strings.clone(meshName, context.allocator)

            currentBufferGroup[clonedMeshName] = {}
            
            meshBuffers := &currentBufferGroup[clonedMeshName]

            meshBuffers.vertexCount = u32(len(mesh.vertices))
            meshBuffers.indexCount  = u32(len(mesh.indices))

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
    fmt.eprintfln("Loaded Model Names: {}", modelNames)
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
        fmt.eprintfln("[WARN] CleanUpBuffersForModel: Model '%s' not found! Buffers might not exist or were already cleaned.", name)
    }
    
    fmt.eprintfln("Cleaning up Vulkan buffers for model '%s'...", name)

    modelBuffers, modelExists := buffers[name]
    if !modelExists {
        fmt.eprintfln("[WARN] CleanUpBuffersForModel: No buffers found for model '%s' in map to clean up.", name)
        return
    }

    for meshName, &meshBuffers in modelBuffers {
        destroy.Buffer(data, &meshBuffers.vertex)
        destroy.Buffer(data, &meshBuffers.index)            
        delete(meshName)
    }
    
    delete(buffers[name])
    delete(name) 

    fmt.eprintfln("Finished cleaning up Vulkan buffers for model '%s'.", name)
}

CleanUpAllBuffers :: proc() -> () {
    if data == nil {
        panic("[ERROR] CleanUpAllBuffers: VulkanData pointer is nil! Call SetDataPointer first.")
    }

    fmt.eprintln("Cleaning up all Vulkan buffers...")
    for modelGroupName, &modelBufferMap in buffers {
        for meshName, &meshBuffers in modelBufferMap {
            destroy.Buffer(data, &meshBuffers.vertex)
            destroy.Buffer(data, &meshBuffers.index)
            delete(meshName)
        }
        delete(modelBufferMap) 
        delete(modelGroupName)
    }
    delete(buffers)
    fmt.eprintln("Finished cleaning up all Vulkan buffers.")
    return
}


VkDrawMesh :: proc(
    cmd: ^vk.CommandBuffer = nil,
    name: string           = "",
    meshName: string       = ""
) -> () {
    // fmt.eprintfln("DEBUG: VkDrawMesh called with name='%s', meshName='%s'", name, meshName)
    // fmt.eprintfln("DEBUG: Buffers map content inside VkDrawMesh: %v", buffers)

    modelBuffers, modelExists := buffers[name]
    if !modelExists {
        fmt.eprintfln("[ERROR] VkDrawMesh: No buffers found for model '%s'", name)
        return
    }
    
    meshBuffer, meshExits := modelBuffers[meshName]
    if !meshExits {
        fmt.eprintfln("[ERROR] VkDrawMesh: No buffers found for model '%s', mesh '%s'", name, meshName)
        return
    }

    offsets:       []vk.DeviceSize = { 0 }
    vertexBuffers: []vk.Buffer = { meshBuffer.vertex.this }

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
