package vk_create

import "core:log"
import "core:c"

import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"
import s "../../../shared"

ImageInfo :: proc(
    imageInfo: ^vk.DescriptorImageInfo = nil,
    imageView: ^vk.ImageView           = nil,
    sampler: ^vk.Sampler               = nil,
    imageLayout: vk.ImageLayout        = .SHADER_READ_ONLY_OPTIMAL,
) -> () {
    imageInfo^ = {
        imageLayout = imageLayout,
        imageView   = imageView^,
        sampler     = sampler^,
    }
    return
}

DescriptorSetLayout_UBO :: proc(data: ^t.VulkanData) -> () {
    using data
    good: bool = true

    MAX_FRAMES_IN_FLIGHT := u32(renderData.MAX_FRAMES_IN_FLIGHT)

    log.debug("\t UBO")
    
    descriptors["ubo"] = {}
    descriptor := &descriptors["ubo"]
    descriptor.poolName = "global"
    descriptor.sets = make([]vk.DescriptorSet, MAX_FRAMES_IN_FLIGHT)

    descriptor.bindings = make([]vk.DescriptorSetLayoutBinding, 1)
    descriptor.bindings[0] = LayoutBinding_2(
        0,
        .UNIFORM_BUFFER,
        { .VERTEX, .FRAGMENT }
    )

    descriptor.layoutInfo = LayoutInfo_1(descriptor.bindings)

    good = DescriptorSetLayout(
        data,
        &descriptor.layoutInfo,
        &descriptor.setLayout
    )
    if !good {
        panic("Failed to create UBO Descriptor Set Layout")
    }
    assert(descriptor.setLayout != 0x0, "UBO descriptor set layout is nil!")

    descriptor.setsLayouts = make([]vk.DescriptorSetLayout, MAX_FRAMES_IN_FLIGHT)
    for &l in descriptor.setsLayouts do l = descriptor.setLayout

    assert(descriptor.sets             != nil, "UBO descriptor is nil!")
    assert(descriptor.setLayout        != 0x0, "UBO descriptor set layout is nil!")
    assert(descriptor.setsLayouts      != nil, "UBO descriptor layouts is nil!")
    assert(descriptor.setsLayouts[0] != 0x0, "UBO descriptor layout is nil!")
}

DescriptorSetLayout_GBuffers :: proc(data: ^t.VulkanData) -> () {
    using data
    good: bool = true

    MAX_FRAMES_IN_FLIGHT := u32(renderData.MAX_FRAMES_IN_FLIGHT)

    log.debug("\t G-Buffer Samplers")
    
    descriptors["gBuffers"] = {}
    descriptor := &descriptors["gBuffers"]
    descriptor.poolName = "global"
    descriptor.sets = make([]vk.DescriptorSet, MAX_FRAMES_IN_FLIGHT)

    descriptor.bindings = make([]vk.DescriptorSetLayoutBinding, 3)
    descriptor.bindings[0] = LayoutBinding_2(
        0,
        .COMBINED_IMAGE_SAMPLER,
        { .FRAGMENT }
    )
    descriptor.bindings[1] = LayoutBinding_2(
        1,
        .COMBINED_IMAGE_SAMPLER,
        { .FRAGMENT }
    )
    descriptor.bindings[2] = LayoutBinding_2(
        2,
        .COMBINED_IMAGE_SAMPLER,
        { .FRAGMENT }
    )

    descriptor.layoutInfo = LayoutInfo_1(descriptor.bindings)

    good = DescriptorSetLayout(
        data,
        &descriptor.layoutInfo,
        &descriptor.setLayout
    )
    if !good {
        panic("Failed to create G-Buffer Sampler Descriptor Set Layout")
    }
    assert(descriptor.setLayout != 0x0, "G-Buffer sampler descriptor set layout is nil!")

    descriptor.setsLayouts = make([]vk.DescriptorSetLayout, MAX_FRAMES_IN_FLIGHT)
    for &l in descriptor.setsLayouts do l = descriptor.setLayout

    assert(descriptor.sets             != nil, "G-Buffer samplers descriptor sets are nil!")
    assert(descriptor.setLayout        != 0x0, "G-Buffer samplers descriptor set layout is nil!")
    assert(descriptor.setsLayouts      != nil, "G-Buffer samplers descriptor layouts is nil!")
    assert(descriptor.setsLayouts[0] != 0x0, "G-Buffer samplers descriptor layout is nil!")
}

DescriptorSetLayouts :: proc(
    data: ^t.VulkanData
) -> () {
    log.debug("Creating Descriptor Set Layouts")
    DescriptorSetLayout_UBO(data)
    DescriptorSetLayout_GBuffers(data)
    return
}

DescriptorPools :: proc(data: ^t.VulkanData) -> () {
    using data
    log.debug("Creating Descriptor Pools")

    MAX_FRAMES_IN_FLIGHT := u32(renderData.MAX_FRAMES_IN_FLIGHT)

    globalPool := descriptorPools["global"]
    {
        globalPool.pools = []vk.DescriptorPoolSize{
            {
                type            = .UNIFORM_BUFFER,
                descriptorCount = MAX_FRAMES_IN_FLIGHT,
            },
            {
                type            = .COMBINED_IMAGE_SAMPLER,
                descriptorCount = 3 * MAX_FRAMES_IN_FLIGHT,
            },
        }
        globalPool.poolCount = u32(len(globalPool.pools))
        assert(len(globalPool.pools) != 0, "Descriptor pools are empty!")

        globalPool.createInfo = DescriptorPoolCreateInfo(
            data,
            &globalPool,
            raw_data(globalPool.pools),
            globalPool.poolCount,
            maxSets = MAX_FRAMES_IN_FLIGHT + MAX_FRAMES_IN_FLIGHT
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

DescriptorSets_UBO :: proc(data: ^t.VulkanData) -> () {
    using data
    log.debug("\t UBO")
    MAX_FRAMES_IN_FLIGHT := u32(renderData.MAX_FRAMES_IN_FLIGHT)
    globalPool      := descriptorPools["global"]
    
    log.debug("\t\t Allocation")
    {
        uboDescriptor := &descriptors["ubo"]
        using uboDescriptor;

        assert(setLayout != 0x0, "UBO Descriptor set layout is nil!")
        log.info(fmt.aprintf("UBO sets count before allocation: %v", len(sets)))

        allocInfo: vk.DescriptorSetAllocateInfo = {}
        DescriptorAllocateInfo(&allocInfo, &globalPool, raw_data(setsLayouts), u32(len(setsLayouts)))

        good := DescriptorAllocate(
            data,
            &allocInfo,
            raw_data(uboDescriptor.sets)
        )
        if !good {
            panic("Failed to allocate UBO descriptor sets")
        }
        log.info(fmt.aprintf("UBO sets count after allocation: %v", len(sets)))
    }

    log.debug("\t\t Updating")
    {
        uboDescriptor := &descriptors["ubo"]
        uboBuffers    := (&uniformBuffers["ubo"]).this

        for _, i in uboBuffers {
            log.assert(uboBuffers[i] != {}, "UBO Buffer is nil")
            us := &uboDescriptor.sets[i]

            bufferInfo: vk.DescriptorBufferInfo = {}
            BufferInfo(
                &bufferInfo,
                uboBuffers[i],
                size_of(s.UBO)
            )

            writeUbo_temp: vk.WriteDescriptorSet = {}
            DescriptorWrite(
                &writeUbo_temp,
                us,
                .UNIFORM_BUFFER,
                bufferInfo = &bufferInfo,
                binding = 0,
            )
            vk.UpdateDescriptorSets(
                logical.device,
                1,
                &writeUbo_temp,
                0,
                nil
            )
        }
    }
}

DescriptorSets_GBuffers :: proc(data: ^t.VulkanData) -> () {
    using data
    log.debug("\t G-Buffer Samplers")
    MAX_FRAMES_IN_FLIGHT := u32(renderData.MAX_FRAMES_IN_FLIGHT)
    globalPool      := descriptorPools["global"]

    log.debug("\t\t Allocation")
    {
        gBufferDescriptor := &descriptors["gBuffers"]
        using gBufferDescriptor;

        assert(setLayout != 0x0, "G-Buffer Descriptor set layout is nil!")
        log.info(fmt.aprintf("G-Buffer sets count before allocation: %v", len(sets)))

        allocInfo: vk.DescriptorSetAllocateInfo = {}
        DescriptorAllocateInfo(&allocInfo, &globalPool, raw_data(setsLayouts), u32(len(setsLayouts)))

        good := DescriptorAllocate(
            data,
            &allocInfo,
            raw_data(gBufferDescriptor.sets)
        )
        if !good {
            panic("Failed to allocate G-Buffer descriptor set")
        }
        log.info(fmt.aprintf("G-Buffer sets count after allocation: %v", len(sets)))
    }

    log.debug("\t\t Updating")
    {
        gBufferDescriptor := &descriptors["gBuffers"]
        gBufferSampler    := &samplers["gBuffers"]
        
        positionGBuffer   := gBuffers["geometry.position"]
        albedoGBuffer     := gBuffers["geometry.albedo"]
        normalGBuffer     := gBuffers["geometry.normal"]

        for i: int = 0; i < renderData.MAX_FRAMES_IN_FLIGHT; i += 1 {
            ds := &gBufferDescriptor.sets[i]

            writesForCurrentSet: []vk.WriteDescriptorSet = make([]vk.WriteDescriptorSet, 3)

            positionImageInfo: vk.DescriptorImageInfo = {}
            ImageInfo(
                &positionImageInfo,
                &positionGBuffer.views[i],
                gBufferSampler,
                .SHADER_READ_ONLY_OPTIMAL,
            )
            DescriptorWrite(
                &writesForCurrentSet[0],
                ds,
                .COMBINED_IMAGE_SAMPLER,
                binding = 0,
                imageInfo = &positionImageInfo,
            )

            albedoImageInfo: vk.DescriptorImageInfo = {}
            ImageInfo(
                &albedoImageInfo,
                &albedoGBuffer.views[i],
                gBufferSampler,
                .SHADER_READ_ONLY_OPTIMAL,
            )
            DescriptorWrite(
                &writesForCurrentSet[1],
                ds,
                .COMBINED_IMAGE_SAMPLER,
                binding = 1,
                imageInfo = &albedoImageInfo,
            )

            normalImageInfo: vk.DescriptorImageInfo = {}
            ImageInfo(
                &normalImageInfo,
                &normalGBuffer.views[i],
                gBufferSampler,
                .SHADER_READ_ONLY_OPTIMAL,
            )
            DescriptorWrite(
                &writesForCurrentSet[2],
                ds,
                .COMBINED_IMAGE_SAMPLER,
                binding = 2,
                imageInfo = &normalImageInfo,
            )

            vk.UpdateDescriptorSets(
                logical.device,
                u32(len(writesForCurrentSet)),
                raw_data(writesForCurrentSet),
                0,
                nil
            )
        }
    }
}


DescriptorSets :: proc(data: ^t.VulkanData) -> () {
    log.debug("Creating Descriptor Sets")
    DescriptorSets_UBO(data)
    DescriptorSets_GBuffers(data)
    return
}

BufferInfo :: proc(
    bufferInfo: ^vk.DescriptorBufferInfo = nil,
    buffer: t.Buffer                    = {},
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
    write: ^vk.WriteDescriptorSet      = nil,
    set: ^vk.DescriptorSet            = nil,
    descriptorType: vk.DescriptorType = .UNIFORM_BUFFER,
    binding: u32                      = 0,
    arrayElement: u32                 = 0,
    count: u32                        = 1,
    bufferInfo: ^vk.DescriptorBufferInfo = nil,
    imageInfo: ^vk.DescriptorImageInfo  = nil,
    texelBufferView: ^vk.BufferView    = nil,
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
    pool: ^t.DescriptorPool                 = nil,
    layouts: [^]vk.DescriptorSetLayout       = nil,
    count: u32                               = 0,
    pNext: rawptr                           = nil
) -> () {
    allocInfo^ = {
        sType            = .DESCRIPTOR_SET_ALLOCATE_INFO,
        pNext            = pNext,
        descriptorPool   = pool.this,
        descriptorSetCount = count,
        pSetLayouts      = layouts
    }
    return
}

DescriptorAllocate :: proc(
    data: ^t.VulkanData                    = nil,
    allocInfo: ^vk.DescriptorSetAllocateInfo = nil,
    sets: [^]vk.DescriptorSet              = nil
) -> (ok: bool = true) {
    log.debug("Allocating Descriptor Sets")
    result := vk.AllocateDescriptorSets(
        data.logical.device,
        allocInfo,
        sets
    )
    if result != .SUCCESS {
        log.error(fmt.aprintf("Failed to allocate descriptor sets! Error: %v", result))
        ok = false
        return
    }
    log.debug("Allocated Descriptor Sets")
    return
}

DescriptorPoolCreateInfo :: proc(
    data:  ^t.VulkanData                  = nil,
    pool:  ^t.DescriptorPool              = nil,
    pools: [^]vk.DescriptorPoolSize         = nil,
    count: u32                            = 0,
    flags: vk.DescriptorPoolCreateFlags   = {},
    pNext: rawptr = nil,
    maxSets: u32 = 0,
) -> (createInfo: vk.DescriptorPoolCreateInfo = {}) {
    createInfo = {
        sType            = .DESCRIPTOR_POOL_CREATE_INFO,
        pNext            = pNext,
        flags            = flags,
        maxSets          = maxSets,
        poolSizeCount    = count,
        pPoolSizes       = pools,
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
    binding: u32                          = 0,
    type: vk.DescriptorType               = .UNIFORM_BUFFER,
    stageFlags: vk.ShaderStageFlags       = { .FRAGMENT },
    count: u32                            = 1,
    layoutBinding: ^vk.DescriptorSetLayoutBinding = nil,
    immutableSamplers: [^]vk.Sampler     = nil
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
    binding: u32                          = 0,
    type: vk.DescriptorType               = .UNIFORM_BUFFER,
    stageFlags: vk.ShaderStageFlags       = { .FRAGMENT },
    count: u32                            = 1,
    immutableSamplers: [^]vk.Sampler     = nil
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
    data: ^t.VulkanData                  = nil,
    info: ^vk.DescriptorSetLayoutCreateInfo = nil,
    setLayout: ^vk.DescriptorSetLayout      = nil
) -> (ok: bool = true) {
    using data

    log.debug("Creating Descriptor Set Layout")
    result := vk.CreateDescriptorSetLayout(logical.device, info, allocations, setLayout)
    if result != .SUCCESS {
        log.error(fmt.aprintf("Failed to create descriptor set layout! Error: %v", result))
        ok = false
        return
    }
    log.debug("Created Descriptor Set Layout")

    return
}