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

DescriptorSetLayouts :: proc(
    data: ^t.VulkanData = nil
) -> () {
    
    for _, &descriptor in data.descriptors {
        DescriptorSetLayout(
            data,
            &descriptor
        )
        
        delete(descriptor.bindings)
        delete(descriptor.sets)
        delete(descriptor.setsLayouts)
    }
    delete(data.descriptors)

    return
}

DescriptorPools :: proc(
    data: ^t.VulkanData = nil
) -> () {
    
    log.debug("\tDestroying Descriptor Pools")
    for k, &pool in data.descriptorPools {
        
        log.debugf("\t\t * %s", k)
        DescriptorPool(
            data,
            &pool
        )
    }
    delete(data.descriptorPools)

    return
}

DescriptorSetLayout :: proc(
    data: ^t.VulkanData = nil,
    descriptor: ^t.Descriptor = nil
) -> () {
    if descriptor.setLayout != {} {
        vk.DestroyDescriptorSetLayout(
            data.logical.device,
            descriptor.setLayout,
            nil
        )
    }
    return
}


DescriptorPool :: proc(
    data: ^t.VulkanData = nil,
    pool: ^t.DescriptorPool = nil
) -> () {
    pool.createInfo = {}
    pool.poolCount = 0

    if pool.this != {} {
        vk.DestroyDescriptorPool(
            data.logical.device,
            pool.this,
            data.allocations
        )
    }

    assert(pool.this != {}, "Descriptor Pool is not nil!")
    assert(pool.poolCount == 0, "Descriptor Pool Count is not 0!")
    assert(pool.createInfo == {}, "Descriptor Pool Create Info is not nil!")
    return
}