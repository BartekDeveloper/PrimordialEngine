package vk_create

import "core:log"
import "core:c"

import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import "../choose"
import t "../types"
import win "../../window"
import s "../../../shared"

UniformBuffers :: proc(data: ^t.VulkanData) -> () {
    using data;
    good: bool = true

    uboBuffers := uniformBuffers["ubo"]
    imageCount := u32(swapchain.imageCount) 

    log.debug("Creating `UBO` Uniform Buffers")
    {
        bufferSize: vk.DeviceSize = size_of(s.UBO)
        
        uboBuffers.this = make([]t.Buffer, imageCount)

        for i := 0; i < int(imageCount); i += 1 {
            uboBuffers.this[i].this, good = Buffer_return(
                data,
                bufferSize,
                {  .UNIFORM_BUFFER },
                { .HOST_VISIBLE, .HOST_COHERENT },
                &uboBuffers.this[i].mem
            );
            if !good {
                log.panicf("Failed to create `UBO` Uniform Buffer #%d", i) 
            }

            result := MapMemory(data, &uboBuffers.this[i], bufferSize, {})
            if result != .SUCCESS {
                log.panicf("Failed to map `UBO` Uniform Buffer #%d", i) 
            }
        }

        uniformBuffers["ubo"] = uboBuffers
        defer uboBuffers = {}
    }

    return
}

@(require_results)
Buffer_return :: proc(
    data:        ^t.VulkanData          = nil,
    size:        vk.DeviceSize          = 0,
    usage:       vk.BufferUsageFlags    = {},
    properties:  vk.MemoryPropertyFlags = {},
    memory:      ^vk.DeviceMemory       = nil,
) -> (buffer: vk.Buffer, good: bool = true) #optional_ok {
    using data;

    createInfo: vk.BufferCreateInfo = {
        sType       = .BUFFER_CREATE_INFO,
        size        = size,
        usage       = usage,
        sharingMode = .EXCLUSIVE,
    }

    result := vk.CreateBuffer(logical.device, &createInfo, allocations, &buffer)
    if result != .SUCCESS {
        panic("Failed to create buffer!")
    }

    memoryRequirements: vk.MemoryRequirements
    vk.GetBufferMemoryRequirements(logical.device, buffer, &memoryRequirements)

    memType: u32
    memType, good = choose.MemoryType_return(physical.device, memoryRequirements.memoryTypeBits, properties)
    if !good {
        panic("Failed to find suitable memory type!")
    }

    memoryAllocateInfo: vk.MemoryAllocateInfo = {
        sType           = .MEMORY_ALLOCATE_INFO,
        allocationSize  = memoryRequirements.size,
        memoryTypeIndex = memType
    }

    result = vk.AllocateMemory(logical.device, &memoryAllocateInfo, allocations, memory)
    if result != .SUCCESS {
        panic("Failed to allocate buffer memory!")
    }

    vk.BindBufferMemory(logical.device, buffer, memory^, 0)
    if result != .SUCCESS {
        panic("Failed to bind buffer memory!")
    }

    return
}

Buffer_modify :: proc(
    data:        ^t.VulkanData          = nil,
    buffer:      ^t.Buffer              = nil,
    size:        vk.DeviceSize          = 0,
    usage:       vk.BufferUsageFlags    = {},
    properties:  vk.MemoryPropertyFlags = {},
) -> (good: bool = true) {
    using data;

    createInfo: vk.BufferCreateInfo = {
        sType       = .BUFFER_CREATE_INFO,
        size        = size,
        usage       = usage,
        sharingMode = .EXCLUSIVE,
    }

    result := vk.CreateBuffer(logical.device, &createInfo, nil, &buffer.this)
    if result != .SUCCESS {
        panic("Failed to create buffer!")
    }

    memoryRequirements: vk.MemoryRequirements
    vk.GetBufferMemoryRequirements(logical.device, buffer.this, &memoryRequirements)

    memType: u32
    memType, good = choose.MemoryType_return(physical.device, memoryRequirements.memoryTypeBits, properties)
    if !good {
        panic("Failed to find suitable memory type!")
    }

    memoryAllocateInfo: vk.MemoryAllocateInfo = {
        sType           = .MEMORY_ALLOCATE_INFO,
        allocationSize  = memoryRequirements.size,
        memoryTypeIndex = memType
    }

    result = vk.AllocateMemory(logical.device, &memoryAllocateInfo, nil, &buffer.mem)
    if result != .SUCCESS {
        panic("Failed to allocate buffer memory!")
    }

    vk.BindBufferMemory(logical.device, buffer.this, buffer.mem, 0)
    if result != .SUCCESS {
        panic("Failed to bind buffer memory!")
    }

    return
}

Buffer :: proc{
    Buffer_return,
    Buffer_modify,
}

MapMemory :: proc(
    data:   ^t.VulkanData     = nil,
    buffer: ^t.Buffer         = nil,
    size:   vk.DeviceSize     = 0,
    flags:  vk.MemoryMapFlags = {},
) -> (result: vk.Result = .SUCCESS) {
    result = vk.MapMemory(
        data.logical.device,
        buffer.mem,
        0, size,
        flags,
        &buffer.ptr
    )
    return
}