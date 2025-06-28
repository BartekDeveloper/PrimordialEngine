package vk_object

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
    hasIndices: bool,
}

// buffers map now nested by model name and mesh name
buffers: map[string]map[string]VkDataBuffer = {}

// Removed MakeBufferKey, no longer needed

CreateVertexBuffers :: proc(
    name: string = "",
) {
    sceneData, ok := obj.GetModel(name)
    if !ok {
        fmt.eprintfln("[ERROR] Model '%s' not found!", name)
        return
    }

    for _, model in sceneData.objects {
        // Ensure map for this model exists
        if _, exists := buffers[name]; !exists {
            buffers[name] = make(map[string]VkDataBuffer)
        }

        for meshName, mesh in model.meshes {
            if len(mesh.vertices) == 0 {
                continue
            }
            if _, exists := buffers[name][meshName]; exists {
                fmt.eprintfln("[WARN] Buffer for model '%s', mesh '%s' already exists!", model.name, meshName)
                continue
            }

            vkBuffer := &buffers[name][meshName]
            vertexBufferSize := vk.DeviceSize(len(mesh.vertices) * size_of(s.Vertex))
            
            buffer := t.Buffer{}
            good := create.Buffer_modify(
                data,
                &buffer,
                vertexBufferSize,
                { .VERTEX_BUFFER },
                { .HOST_VISIBLE, .HOST_COHERENT },
            )
            if !good {
                fmt.eprintfln("Failed to create vertex buffer for model: %s mesh: %s", model.name, meshName)
                continue
            }

            copy.ToBuffer(
                data,
                &buffer,
                raw_data(mesh.vertices),
                vertexBufferSize,
            )
            vkBuffer.vertex = buffer

            fmt.eprintfln("Created vertex buffer for model: %s mesh: %s", model.name, meshName)
        }
    }
}

CreateIndexBuffers :: proc(
    cmd: ^vk.CommandBuffer = nil,
    name: string = "",
) {
    sceneData, ok := obj.GetModel(name)
    if !ok {
        fmt.eprintfln("[ERROR] Model '%s' not found!", name)
        return
    }

    
    for name, &model in sceneData.objects {

        // Ensure map for this model exists (just in case)
        if _, exists := buffers[name]; !exists {
            buffers[name] = make(map[string]VkDataBuffer)
        }

        for meshName, mesh in model.meshes {
            if len(mesh.indices) == 0 {
                continue
            }

            vkBuffer, exists := &buffers[name][meshName]
            if !exists {
                fmt.eprintfln("[ERROR] Vertex buffer for model '%s', mesh '%s' doesn't exist! Create vertex buffer first.", name, meshName)
                continue
            }

            indexBufferSize := vk.DeviceSize(len(mesh.indices) * size_of(u32))
            buffer := t.Buffer{}

            good := create.Buffer_modify(
                data,
                &buffer,
                indexBufferSize,
                { .INDEX_BUFFER },
                { .HOST_VISIBLE, .HOST_COHERENT },
            )
            if !good {
                fmt.eprintfln("[ERROR] Failed to create index buffer for model: %s mesh: %s", model.name, meshName)
                continue
            }

            copy.ToBuffer(
                data,
                &buffer,
                raw_data(mesh.indices),
                indexBufferSize,
            )

            vkBuffer.index = buffer
            vkBuffer.hasIndices = true

            fmt.eprintfln("Created index buffer for model: %s mesh: %s", model.name, meshName)
        }
    }
}

VkDraw :: proc(
    cmd: ^vk.CommandBuffer = nil,
    sceneName: string = "",
    modelName: string = "",
    meshIndex: u32 = 0,
    instances: u32 = 1,
    firstIndex: u32 = 0,
    firstInstance: u32 = 0,
) -> () {
    if cmd == nil {
        fmt.eprintln("[ERROR] VkDraw: Command buffer is nil!")
        return
    }

    sceneData, ok := obj.GetModel(sceneName)
    if !ok {
        fmt.eprintfln("[ERROR] VkDraw: Scene '%s' not found!", sceneName)
        return
    }

    model, exists := sceneData.objects[modelName]
    if !exists {
        fmt.eprintfln("[ERROR] VkDraw: Model '%s' not found in scene '%s'!", modelName, sceneName)
        return
    }

    meshes := model.meshes
    meshCount: u32 = u32(len(meshes))
    if meshIndex >= meshCount {
        fmt.eprintfln("[ERROR] VkDraw: meshIndex %d out of range for model '%s' (mesh count: %d)", meshIndex, modelName, meshCount)
        return
    }

    meshKey: string = ""
    currentIndex: u32 = 0
    for k, _ in meshes {
        if currentIndex == meshIndex {
            meshKey = k
            break
        }
        currentIndex += 1
    }

    if meshKey == "" {
        fmt.eprintfln("[ERROR] VkDraw: Mesh index %d invalid for model '%s'", meshIndex, modelName)
        return
    }

    mesh := meshes[meshKey]

    vkBuffer, bufferExists := buffers[modelName][meshKey]
    if !bufferExists {
        fmt.eprintfln("[ERROR] VkDraw: Buffer for model '%s' mesh '%s' not found!", modelName, meshKey)
        return
    }

    bufferOffset: vk.DeviceSize = 0
    vk.CmdBindVertexBuffers(cmd^, 0, 1, &vkBuffer.vertex.this, &bufferOffset)

    if vkBuffer.hasIndices {
        vk.CmdBindIndexBuffer(cmd^, vkBuffer.index.this, 0, .UINT32)
        vk.CmdDrawIndexed(
            cmd^,
            mesh.indicesCount,
            instances,
            firstIndex,
            0,
            firstInstance,
        )

        fmt.eprintfln("VkDraw: Drew indexed mesh '%s' [%s]: %d indices, %d instances", modelName, meshKey, mesh.indicesCount, instances)
        return
    }
    
    vk.CmdDraw(
        cmd^,
        mesh.verticesCount,
        instances,
        firstIndex,
        firstInstance,
    )

    fmt.eprintfln("VkDraw: Drew mesh '%s' [%s]: %d vertices, %d instances", modelName, meshKey, mesh.verticesCount, instances)
    return
}
