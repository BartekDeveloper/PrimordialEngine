package vk_create

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"

DescriptorSetLayouts :: proc(data: ^t.VulkanData) -> () {
    using data;
    good: bool = true
    ctx = context

    log.debug("Creating Descriptor Set Layouts")
    log.debug("\t UBO")
    {
        uboBind := LayoutBinding_2(
            0,
            .UNIFORM_BUFFER,
            { .VERTEX, .FRAGMENT }
        )

        uboBindings: []vk.DescriptorSetLayoutBinding = { uboBind }
        uboLayoutInfo := LayoutInfo_1(uboBindings)
        uboSetLayout  := descriptors["ubo"].setLayout

        good = DescriptorSetLayout( 
            data,
        &uboLayoutInfo,
            &uboSetLayout
        )
        if !good {
            log.panic("Failed to create Descriptor Set Layout")
        }
    }

    return
}


LayoutBinding_1 :: proc(
    binding: u32                                  = 0,
    type: vk.DescriptorType                       = .UNIFORM_BUFFER,
    stageFlags: vk.ShaderStageFlags               = { .FRAGMENT },
    count: u32                                    = 1,
    layoutBinding: ^vk.DescriptorSetLayoutBinding = nil,
    immutableSamplers: [^]vk.Sampler              = nil
) -> () {
    context = ctx
    layoutBinding^ = {
        binding            = binding,
        descriptorType     = type,
        descriptorCount    = count,
        stageFlags         = stageFlags,
        pImmutableSamplers = immutableSamplers,
    }
    return
}

LayoutBinding_2 :: proc(
    binding: u32                                  = 0,
    type: vk.DescriptorType                       = .UNIFORM_BUFFER,
    stageFlags: vk.ShaderStageFlags               = { .FRAGMENT },
    count: u32                                    = 1,
    immutableSamplers: [^]vk.Sampler              = nil
) -> (layoutBinding: vk.DescriptorSetLayoutBinding) {
    context = ctx
    layoutBinding = {
        binding            = binding,
        descriptorType     = type,
        descriptorCount    = count,
        stageFlags         = stageFlags,
        pImmutableSamplers = immutableSamplers,
    }
    return
}

LayoutBinding :: proc{
    LayoutBinding_2,
    LayoutBinding_1,
}

LayoutInfo_1 :: proc(
    bindigns: []vk.DescriptorSetLayoutBinding = {}
) -> (layoutInfo: vk.DescriptorSetLayoutCreateInfo) {

    layoutInfo = {
        sType        = .DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
        pNext        = nil,
        flags        = {},
        bindingCount = u32(len(bindigns)),
        pBindings    = raw_data(bindigns),
    }

    return
}

LayoutInfo_2 :: proc(
    binding:    []vk.DescriptorSetLayoutBinding = {},
    layoutInfo: ^vk.DescriptorSetLayoutCreateInfo = nil
) -> () {
    
    layoutInfo^ = {
        sType        = .DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
        pNext        = nil,
        flags        = {},
        bindingCount = u32(len(binding)),
        pBindings    = raw_data(binding),
    }
    
    return
}

LayoutInfo :: proc{
    LayoutInfo_2,
    LayoutInfo_1,
}

DescriptorSetLayout :: proc(
    data: ^t.VulkanData                     = nil,
    info: ^vk.DescriptorSetLayoutCreateInfo = nil,
    setLayout: ^vk.DescriptorSetLayout      = nil
) -> (ok: bool = true) {
    using data;
    context = ctx

    log.debug("Creating Descriptor Set Layout")
    result := vk.CreateDescriptorSetLayout(logical.device, info, nil, setLayout)
    if result != .SUCCESS {
        log.error("Failed to create descriptor set layout!")
        ok = false
        return
    }
    log.debug("Created Descriptor Set Layout")

    return
}