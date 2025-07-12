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
import eobjects "../../objects"
import emath "../../../maths"
import s "../../../shared"

data: ^t.VulkanData = nil
SetDataPointer      :: proc(pData: ^t.VulkanData) { data = pData }
UnSetDataPointer    :: proc()                     { data = nil }

VkDataBuffer :: struct {
    vertex:      t.Buffer,
    index:       t.Buffer,

    vertexCount: u32,
    indexCount:  u32,

    hasIndices:  bool,
}

buffers: map[string]map[string]VkDataBuffer = {}

CreateBuffersForModel_cstr :: proc(name: cstring) {
    fmt.eprintfln("DEBUG: CreateBuffersForModel_cstr called with name='%s'", name)
    name: string = fmt.tprintf("{}", name)
    fmt.eprintfln("DEBUG: CreateBuffersForModel_cstr: name='%s'", name)

    CreateBuffersForModel_str(strings.clone(name))
}

CreateBuffersForModel_str :: proc(
    name: string = "",
) {
    fmt.eprintfln("DEBUG: CreateBuffersForModel_str called with name='%s'", name)

    if utils.IsReallyEmpty(name) {
        fmt.eprintln("[WARN] CreateBuffersForModel: Model name is empty!")
        return
    }

    if data == nil {
        fmt.eprintln("[ERROR] CreateBuffersForModel: VulkanData pointer is nil! Call SetDataPointer first.")
        return
    }

    sceneData, ok := eobjects.GetSceneData(name)
    if !ok {
        fmt.eprintfln("Failed to get scene data for model '%s'", name)
        return
    }

    assert(len(sceneData.meshes) > 0, "Model has no meshes!")

    for &mesh, meshIndex in sceneData.meshes {
        meshName := fmt.tprintf("%s:%d", mesh.name,  meshIndex)

        if _, ok := buffers[name]; !ok {
            buffers[strings.clone(name)] = {}
        }

        buffersSet := &buffers[name]
        buffersSet[strings.clone(meshName)] = {}

        meshBuffers := &buffers[name][meshName]
        meshBuffers.vertexCount = u32(len(mesh.vertices))
        meshBuffers.indexCount  = u32(len(mesh.indices))
        meshBuffers.vertex      = {}
        meshBuffers.index       = {}


        if len(mesh.vertices) > 0 {
            vertexBufferSize := vk.DeviceSize(len(mesh.vertices) * size_of(s.Vertex))

            newVertexBuffer := &meshBuffers.vertex
            good := create.Buffer_modify(
                data,
                newVertexBuffer,
                vertexBufferSize,
                { .VERTEX_BUFFER },
                { .HOST_VISIBLE, .HOST_COHERENT },
            )
            if !good {
                fmt.eprintfln("[ERROR] Failed to create vertex buffer for scene '%s', mesh '%s'", name, meshName)
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

            newIndexBuffer := &meshBuffers.index
            good := create.Buffer_modify(
                data,
                newIndexBuffer,
                indexBufferSize,
                { .INDEX_BUFFER },
                { .HOST_VISIBLE, .HOST_COHERENT },
            )
            if !good {
                fmt.eprintfln("[ERROR] Failed to create index buffer for scene '%s', mesh '%s'", name, meshName)
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

    fmt.eprintfln("\n\nFinished creating Vulkan buffers for model '%s'.", name)
}

CreateBuffersForModel :: proc{
    CreateBuffersForModel_cstr,
    CreateBuffersForModel_str,
}

CreateBuffersForAllModels :: proc() -> () {
    if data == nil {
        fmt.eprintln("[ERROR] CreateBuffersForAllModels: VulkanData pointer is nil! Call SetDataPointer first.")
        return
    }

    if len(eobjects.sceneDataMap) == 0 {
        fmt.eprintln("No models loaded in objects package to create buffers for.")
        return
    }
    fmt.eprintln("Creating Vulkan buffers for all loaded models...")

    for name, _ in eobjects.sceneDataMap {
        fmt.eprintfln("\n\nCreating buffers for model '%s'\n", name)
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

    sceneData, ok := eobjects.GetSceneData(name)
    if !ok {
        fmt.eprintfln("[WARN] CleanUpBuffersForModel: Model '%s' not found! Buffers might not exist or were already cleaned.", name)
    }

    fmt.eprintfln("Cleaning up Vulkan buffers for model '%s'...", name)

    modelBuffers, modelExists := &buffers[name]
    if !modelExists {
        fmt.eprintfln("[WARN] CleanUpBuffersForModel: No buffers found for model '%s' in map to clean up.", name)
        return
    }

    for meshIndex, _ in sceneData.meshes {
        meshName := fmt.tprintf("mesh_%d", meshIndex)
        if meshBuffers, ok := modelBuffers[meshName]; ok {
            destroy.Buffer(data, &meshBuffers.vertex)
            destroy.Buffer(data, &meshBuffers.index)
        }
    }

    delete_key(&buffers, name)

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
            delete_key(&modelBufferMap, meshName)
        }
        delete(modelBufferMap)
        delete_key(&buffers, modelGroupName)
    }
    delete(buffers)
    fmt.eprintln("Finished cleaning up all Vulkan buffers.")
    return
}
