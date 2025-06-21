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
import s "../../../shared"

DescriptorSetLayouts :: proc(
    data: ^t.VulkanData
) -> () {
    using data;
    good: bool = true

    MAX_FRAMES_IN_FLIGHT := u32(renderData.MAX_FRAMES_IN_FLIGHT)

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
        uboSetLayout: vk.DescriptorSetLayout

        good = DescriptorSetLayout( 
            data,
        &uboLayoutInfo,
            &uboSetLayout
        )
        if !good {
            panic("Failed to create Descriptor Set Layout")
        }
        assert(uboSetLayout != 0x0, "UBO descriptor set layout is nil!")
        
        uboSetLayouts := make([]vk.DescriptorSetLayout, MAX_FRAMES_IN_FLIGHT)
        for &l in uboSetLayouts do l = uboSetLayout

        uboDescriptor := t.Descriptor{
            setLayout   = uboSetLayout,
            poolName    = "global",
            sets        = make([]vk.DescriptorSet, MAX_FRAMES_IN_FLIGHT),
            setsLayouts = uboSetLayouts
        }

        assert(uboDescriptor.sets           != nil, "UBO descriptor is nil!")
        assert(uboDescriptor.setLayout      != 0x0, "UBO descriptor set layout is nil!")
        assert(uboDescriptor.setsLayouts    != nil, "UBO descriptor layouts is nil!")
        assert(uboDescriptor.setsLayouts[0] != 0x0, "UBO descriptor layout is nil!")
        
        descriptors["ubo"] = uboDescriptor
    }

    return
}

DescriptorPools :: proc(data: ^t.VulkanData) -> () {
    using data;
    log.debug("Creating Descriptor Pools")

    MAX_FRAMES_IN_FLIGHT := u32(renderData.MAX_FRAMES_IN_FLIGHT)

    globalPool := descriptorPools["global"]
    {
        globalPool.pools = []vk.DescriptorPoolSize{
            {
                type            = .UNIFORM_BUFFER,
                descriptorCount = MAX_FRAMES_IN_FLIGHT,
            }
        }
        globalPool.poolCount = u32(len(globalPool.pools))
        assert(len(globalPool.pools) != 0, "Descriptor pools are empty!")

        globalPool.createInfo = DescriptorPoolCreateInfo(
            data,
            &globalPool,
            raw_data(globalPool.pools),
            globalPool.poolCount
        )

        res := DescriptorPool(data, &globalPool)
        if res != .SUCCESS {
            panic("Failed to create descriptor pools")
        }
        assert(globalPool.this != 0x0, "Descriptor pool is nil!")

        descriptorPools["global"] = globalPool
    }

    return
}



DescriptorSets :: proc(data: ^t.VulkanData) -> () {
    using data;
    log.debug("Creating Descriptor Sets")
    MAX_FRAMES_IN_FLIGHT := u32(renderData.MAX_FRAMES_IN_FLIGHT)

    globalPool    := descriptorPools["global"]
    uboDescriptor := descriptors["ubo"]
    
    log.debug("\t Allocation")
    {
        log.debug("\t\t UBO")
        {
            using uboDescriptor;

            assert(setLayout != 0x0, "Descriptor set layout is nil!")
            log.info(len(sets))
            
            allocInfo: vk.DescriptorSetAllocateInfo = {}
            DescriptorAllocateInfo(&allocInfo, &globalPool, raw_data(setsLayouts), u32(len(setsLayouts)))

            good := DescriptorAllocate(
                data,
                &allocInfo,
                raw_data(uboDescriptor.sets)
            )
            if !good {
                panic("Failed to allocate descriptor sets")
            }
            log.info(len(sets))


            descriptors["ubo"] = uboDescriptor
        }
    }



    log.debug("\t Updating")
    {
        log.debug("\t\t UBO")
        uboDescriptor = descriptors["ubo"]
        uboBuffers := uniformBuffers["ubo"].this
        {
            using uboDescriptor;

            for i := 0; i < int(MAX_FRAMES_IN_FLIGHT); i += 1 {
                log.assert(uboBuffers[i] != {}, "UBO Buffer is nil")
                us := &uboDescriptor.sets[i]

                bufferInfo: vk.DescriptorBufferInfo
                BufferInfo(
                    &bufferInfo,
                    uboBuffers[i],
                    size_of(s.UBO)
                )

                uboWrite: vk.WriteDescriptorSet
                DescriptorWrite(
                    &uboWrite,
                    us,
                    .UNIFORM_BUFFER,
                    bufferInfo = &bufferInfo
                )

            }
            descriptors["ubo"] = uboDescriptor
        }
    }


    return
}

BufferInfo :: proc(
    bufferInfo: ^vk.DescriptorBufferInfo = nil,
    buffer: t.Buffer                     = {},
    size: int                            = 0,
    offset: vk.DeviceSize                = 0,
) -> () {
    bufferInfo^ = {
        buffer = buffer.this,
        range  = vk.DeviceSize(size), 
        offset = offset,
    }
    return
}

DescriptorWrite :: proc(
    write: ^vk.WriteDescriptorSet        = nil,
    set: ^vk.DescriptorSet               = nil,
    descriptorType: vk.DescriptorType    = .UNIFORM_BUFFER,
    binding: u32                         = 0,
    arrayElement: u32                    = 0,
    count: u32                           = 1,
    bufferInfo: ^vk.DescriptorBufferInfo = nil,
    imageInfo: ^vk.DescriptorImageInfo   = nil,
    texelBufferView: ^vk.BufferView      = nil,
) -> () {

    write^ = {
        sType            = .WRITE_DESCRIPTOR_SET,
        pNext            = nil,
        dstSet           = set^,
        dstBinding       = binding,
        dstArrayElement  = arrayElement,
        descriptorCount  = count,
        descriptorType   = descriptorType,
        pBufferInfo      = bufferInfo,
        pImageInfo       = imageInfo,
        pTexelBufferView = texelBufferView,
    }
    return
}

DescriptorAllocateInfo :: proc(
    allocInfo: ^vk.DescriptorSetAllocateInfo = nil,
    pool: ^t.DescriptorPool                  = nil,
    layouts: [^]vk.DescriptorSetLayout       = nil,
    count: u32                               = 0,
    pNext: rawptr                            = nil
) -> () {
    allocInfo^ = {
        sType              = .DESCRIPTOR_SET_ALLOCATE_INFO,
        pNext              = pNext,
        descriptorPool     = pool.this,
        descriptorSetCount = count,
        pSetLayouts        = layouts
    }
    return
}

DescriptorAllocate :: proc(
    data: ^t.VulkanData                      = nil,
    allocInfo: ^vk.DescriptorSetAllocateInfo = nil,
    sets: [^]vk.DescriptorSet                = nil
) -> (ok: bool = true) {
    log.debug("Allocating Descriptor Sets")
    result := vk.AllocateDescriptorSets(
        data.logical.device,
        allocInfo,
        sets
    )
    if result != .SUCCESS {
        log.error("Failed to allocate descriptor sets!")
        ok = false
        return
    }
    log.debug("Allocated Descriptor Sets")
    return
}

DescriptorPoolCreateInfo :: proc(
    data:  ^t.VulkanData                = nil,
    pool:  ^t.DescriptorPool            = nil,
    pools: [^]vk.DescriptorPoolSize     = nil,
    count: u32                          = 0,
    flags: vk.DescriptorPoolCreateFlags = {},
    pNext: rawptr = nil,
) -> (createInfo: vk.DescriptorPoolCreateInfo = {}) {
    createInfo = {
        sType           = .DESCRIPTOR_POOL_CREATE_INFO,
        pNext           = pNext,
        flags           = flags,
        maxSets         = count * u32(data.renderData.MAX_FRAMES_IN_FLIGHT),
        poolSizeCount   = count,
        pPoolSizes      = pools,
    }

    return
}

DescriptorPool :: proc(
    data: ^t.VulkanData,
    pool: ^t.DescriptorPool,
) -> (result: vk.Result = .SUCCESS) {
    log.debug("Creating Descriptor Pool")
    result = vk.CreateDescriptorPool(
        data.logical.device,
        &pool.createInfo,
        data.allocations,
        &pool.this
    )
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
    bindings: []vk.DescriptorSetLayoutBinding = {}
) -> (layoutInfo: vk.DescriptorSetLayoutCreateInfo) {

    layoutInfo = {
        sType        = .DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
        pNext        = nil,
        flags        = {},
        bindingCount = u32(len(bindings)),
        pBindings    = raw_data(bindings),
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

    log.debug("Creating Descriptor Set Layout")
    result := vk.CreateDescriptorSetLayout(logical.device, info, allocations, setLayout)
    if result != .SUCCESS {
        log.error("Failed to create descriptor set layout!")
        ok = false
        return
    }
    log.debug("Created Descriptor Set Layout")

    return
}