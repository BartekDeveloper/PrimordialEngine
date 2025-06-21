package vk_destroy 

import "core:log"
import "core:mem"
import "core:c"
import "core:os"
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
    }
    return
}

Buffer :: proc(
    data: ^t.VulkanData = nil,
    buffer: ^t.Buffer = nil
) -> () {
    if buffer.this != {} {
        vk.DestroyBuffer(
            data.logical.device,
            buffer.this,
            data.allocations
        )
    }

    vk.FreeMemory(
        data.logical.device,
        buffer.mem,
        data.allocations
    )

    buffer.ptr = nil

    assert(buffer.this != {}, "Buffer is not destroyed!")
    assert(buffer.mem != {}, "Buffer memory is not freed!")
    assert(buffer.ptr == nil, "Buffer pointer is not nil!")
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
