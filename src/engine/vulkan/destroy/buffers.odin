package vk_destroy 

import "core:log"
import "core:mem"
import "core:c"

import "core:fmt"
import "core:strings"
import "core:strconv"
import rn "base:runtime"

import vk "vendor:vulkan"

import t "../types"

UniformBuffers :: proc(
    data: ^t.VulkanData = nil,
    ctx: rn.Context     = {}
) -> () {
    for _, &buffers in data.uniformBuffers {
        Buffers(
            data,
            &buffers
        )
        delete(buffers.this)
    }
    delete(data.uniformBuffers)

    return
}

Buffer :: proc(
    data: ^t.VulkanData = nil,
    buffer: ^t.Buffer = nil
) -> () {
    defer fmt.eprintfln("Destroying Vulkan buffer '{}'...\n : ('{}' - '{}'')", buffer.ptr, buffer.this, buffer.mem)

    if data == nil {
        panic("VulkanData pointer is nil!.")
    }
    if buffer.this != {} && buffer.this != 0x0 {
        vk.DestroyBuffer(
            data.logical.device,
            buffer.this,
            data.allocations
        )
    }
    if buffer.mem != {} && buffer.mem != 0x0 {
        vk.FreeMemory(
            data.logical.device,
            buffer.mem,
            data.allocations
        )
    }
    buffer.ptr = nil
    
    return
}

Buffers :: proc(
    data: ^t.VulkanData = nil,
    buffers: ^t.Buffers = nil
) -> () {
    for &buffer, i in buffers.this {
        Buffer(
            data,
            &buffer
        )
    }
    return
}
