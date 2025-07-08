package vk_create

import "core:log"
import "core:c"

import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import "../load"
import t "../types"
import win "../../window"
import s "../../../shared"

Pipelines :: proc(data: ^t.VulkanData) -> () {
    using data
    good: bool = true

    viewports["global"] = {
        x        = 0.0,
        y        = 0.0,
        minDepth = 0.0,
        maxDepth = 1.0,
        width    = (f32)(swapchain.extent.width),
        height   = (f32)(swapchain.extent.height),
    }
    scissors["global"] = {
        offset = { x = 0.0, y = 0.0 },
        extent = swapchain.extent,
    }

    log.debug("Creating Pipelines")
    log.debug("\t Geometry")
    {
        pipelines["geometry"] = {}
        geometry := &pipelines["geometry"]

        log.debug("\t\t Creating Shaders")
        geometry.shaders = {
            { "geometry.vert.spv", .VERTEX },
            { "geometry.frag.spv", .FRAGMENT },
        }
        geometry.stages = ShaderStages(data, load.GetModule, ..geometry.shaders)
        geometry.setLayouts = { descriptors["ubo"].setLayout }

        pVertexData: PipelineVertexData = {}
        AddBinding(
            &pVertexData,
            t.vibd{
                binding   = 0,
                stride    = size_of(s.Vertex),
                inputRate = .VERTEX,
            }
        )
        AddAttribute(
            &pVertexData,
            t.viad{
                location = 0,
                binding  = 0,
                format   = .R32G32B32_SFLOAT,
                offset   = u32(offset_of(s.Vertex, pos)),
            },
            t.viad{
                location = 1,
                binding  = 0,
                format   = .R32G32B32_SFLOAT,
                offset   = u32(offset_of(s.Vertex, norm)),
            },
            t.viad{
                location = 2,
                binding  = 0,
                format   = .R32G32_SFLOAT,
                offset   = u32(offset_of(s.Vertex, uv0)),
            }
        )
        defer CleanPipelineVertexData(&pVertexData)

        pDynamicStates:       [2]vk.DynamicState = {}
        pVertexInputInfo       := DefaultVertexInput(&pVertexData)
        pInputAssemblyInfo     := DefaultInputAssembly(topology = .TRIANGLE_LIST)
        pViewportState         := DefaultViewportState(1, 1)
        pRasterizationInfo     := DefaultRasterization(polygonMode = .FILL)
        pMultisampleState      := DefaultMultisample()
        pDepthStencil          := DefaultDepthStencil(depthTestEnable = false, depthWriteEnable = true)
        pColorBlendAttachments := DefaultFillColorBlendAttachments(3, blendEnable = false)
        pColorBlending         := DefaultColorBlending(u32(len(pColorBlendAttachments)), raw_data(pColorBlendAttachments))
        pDynamicState          := DefaultDynamicStates(&pDynamicStates)

        defer delete(pColorBlendAttachments)

        geometry.states = t.GraphicsInfoStates{ 
            vertex       = &pVertexInputInfo,
            assembly     = &pInputAssemblyInfo,
            viewport     = &pViewportState,
            raster       = &pRasterizationInfo,
            multisample  = &pMultisampleState,
            depthStencil = &pDepthStencil,
            colorBlend   = &pColorBlending,
            dynamics     = &pDynamicState,
        }

        pPipelineLayoutCreateInfo := DefaultPipelineLayoutCreateInfo(
            u32(len(geometry.setLayouts)),
            raw_data(geometry.setLayouts)
        )
        good = PipelineLayout(data, &pPipelineLayoutCreateInfo, &geometry.layout)
        if !good {
            panic("Failed to create Pipeline Layout")
        }

        pCacheCreateInfo := DefaultPipelineEmptyCacheCreateInfo()
        good = PipelineCache(data, &pCacheCreateInfo, &geometry.cache)
        if !good {
            panic("Failed to create Pipeline Cache")
        }

        geometry.createInfo = GraphicsPipelineInfo(
            geometry.states,
            len(geometry.stages),
            raw_data(geometry.stages),
            geometry.layout,
            passes["combined"].renderPass,
            subpass = 0
        )

        good = GraphicsPipeline(
            data,
            &geometry.pipeline,
            t.GraphicsPipelineData{
                cache     = &geometry.cache,
                infoCount = 1,
                info      = &geometry.createInfo.(vk.GraphicsPipelineCreateInfo),
            }
        )
        if !good {
            panic("Failed to create Graphics Pipeline")
        }
        Label_single(
            logical.device,
            "pipeline - geometry",
            geometry.pipeline,
            .PIPELINE
        )

        assert(geometry.pipeline != {}, "Pipeline is nil!")
    }

    log.debug("\t Light")
    {
        log.debug("\t\t Creating Shaders")\
        pipelines["light"] = {}
        light := &pipelines["light"]

        light.shaders = {
            { "light.vert.spv", .VERTEX   },
            { "light.frag.spv", .FRAGMENT },
        }
        light.stages     = ShaderStages(data, load.GetModule, ..light.shaders)
        light.setLayouts = { descriptors["ubo"].setLayout, descriptors["gBuffers"].setLayout }

        pVertexData:          PipelineVertexData = {{}, {}}
        
        pDynamicStates:       [2]vk.DynamicState = {}
        pVertexInputInfo       := DefaultVertexInput(&pVertexData)
        pInputAssemblyInfo     := DefaultInputAssembly()
        pViewportState         := DefaultViewportState(1, 1)
        pRasterizationInfo     := DefaultRasterization()
        pMultisampleState      := DefaultMultisample()
        pDepthStencil          := DefaultDepthStencil()
        pColorBlendAttachments := DefaultFillColorBlendAttachments(1, blendEnable = false)
        pColorBlending         := DefaultColorBlending(u32(len(pColorBlendAttachments)), raw_data(pColorBlendAttachments))
        pDynamicState          := DefaultDynamicStates(&pDynamicStates)
        
        defer delete(pColorBlendAttachments)

        light.states = t.GraphicsInfoStates{ 
            vertex        = &pVertexInputInfo,
            assembly      = &pInputAssemblyInfo,
            viewport      = &pViewportState,
            raster        = &pRasterizationInfo,
            multisample   = &pMultisampleState,
            depthStencil  = &pDepthStencil,
            colorBlend    = &pColorBlending,
            dynamics      = &pDynamicState,
        }

        pPipelineLayoutCreateInfo := DefaultPipelineLayoutCreateInfo(
            u32(len(light.setLayouts)),
            raw_data(light.setLayouts)
        )
        good = PipelineLayout(data, &pPipelineLayoutCreateInfo, &light.layout)
        if !good {
            panic("Failed to create Pipeline Layout")
        }

        pCacheCreateInfo := DefaultPipelineEmptyCacheCreateInfo()
        good = PipelineCache(data, &pCacheCreateInfo, &light.cache)
        if !good {
            panic("Failed to create Pipeline Cache")
        }

        light.createInfo = GraphicsPipelineInfo(
            light.states,
            len(light.stages),
            raw_data(light.stages),
            light.layout,
            passes["combined"].renderPass,
            subpass = 1
        )

        good = GraphicsPipeline(
            data,
            &light.pipeline,
            t.GraphicsPipelineData{
                cache     = &light.cache,
                infoCount = 1,
                info      = &light.createInfo.(vk.GraphicsPipelineCreateInfo),
            }
        )
        if !good {
            panic("Failed to create Graphics Pipeline")
        }
        Label_single(
            logical.device,
            "pipeline - light",
            light.pipeline,
            .PIPELINE
        )

        assert(light.pipeline != {}, "Pipeline is nil!")
    }

    return
}


DefaultVertexInput :: proc(
    data: ^PipelineVertexData
) -> (vertexInput: vk.PipelineVertexInputStateCreateInfo) {
    using data

    vertexInput = {
        sType                           = .PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
        pNext                           = nil,
        flags                           = {},
        vertexBindingDescriptionCount   = u32(len(bindings)),
        pVertexBindingDescriptions      = raw_data(bindings),
        vertexAttributeDescriptionCount = u32(len(attributes)),
        pVertexAttributeDescriptions    = raw_data(attributes),
    }

    return
}

DefaultInputAssembly :: proc(
    topology: vk.PrimitiveTopology                  = .TRIANGLE_LIST,
    restartEnable: b32                              = false,
    flags: vk.PipelineInputAssemblyStateCreateFlags = {}
) -> (inputAssembly: vk.PipelineInputAssemblyStateCreateInfo) {
    inputAssembly = {
        sType                   = .PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
        pNext                   = nil,
        flags                   = flags,
        topology                = topology,
        primitiveRestartEnable  = restartEnable,
    }
    return
}

DefaultViewportState :: proc(
    viewportCount: u32                         = 1,
    scissorCount: u32                          = 1,
    viewports: ^vk.Viewport                    = nil,
    scissors: ^vk.Rect2D                       = nil,
    pNext: rawptr                              = nil,
    flags: vk.PipelineViewportStateCreateFlags = {}
) -> (viewportState: vk.PipelineViewportStateCreateInfo) {
    viewportState = {
        sType         = .PIPELINE_VIEWPORT_STATE_CREATE_INFO,
        pNext         = pNext,
        flags         = flags,
        viewportCount = viewportCount,
        scissorCount  = scissorCount,
        pViewports    = viewports,
        pScissors     = scissors,
    }
    return
}

DefaultRasterization :: proc(
    cullMode: vk.CullModeFlags                      = nil,
    polygonMode: vk.PolygonMode                     = .FILL,
    lineWidth: f32                                  = 1.0,
    frontFace: vk.FrontFace                         = .COUNTER_CLOCKWISE,
    rasterizerDiscardEnable: b8                     = false,
    depthBiasEnable: b8                             = false,
    depthBiasConstantFactor: f32                    = 0,
    depthBiasClamp: f32                             = 0,
    depthBiasSlopeFactor: f32                       = 0,
    flags: vk.PipelineRasterizationStateCreateFlags = {},
    pNext: rawptr                                   = nil,
) -> (rasterization: vk.PipelineRasterizationStateCreateInfo) {
    rasterization = {
        sType                   = .PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
        pNext                   = pNext,
        flags                   = flags,
        depthClampEnable        = (b32)(depthBiasEnable),
        rasterizerDiscardEnable = (b32)(rasterizerDiscardEnable),
        polygonMode             = polygonMode,
        cullMode                = cullMode,
        frontFace               = frontFace,
        depthBiasEnable         = (b32)(depthBiasEnable),
        depthBiasConstantFactor = depthBiasConstantFactor,
        depthBiasClamp          = depthBiasClamp,
        depthBiasSlopeFactor    = depthBiasSlopeFactor,
        lineWidth               = lineWidth,
    }
    return
}

DefaultMultisample :: proc(
    rasterizationSamples: vk.SampleCountFlags     = { ._1 },
    sampleShadingEnable: b8                       = false, 
    minSampleShading: f32                         = 1,
    alphaToCoverageEnable: b8                     = false,
    alphaToOneEnable: b8                          = false,
    pSampleMask: ^vk.SampleMask                   = nil,
    pNext: rawptr                                 = nil,
    flags: vk.PipelineMultisampleStateCreateFlags = {}
) -> (multisample: vk.PipelineMultisampleStateCreateInfo) {
    multisample = {
        sType                 = .PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
        pNext                 = pNext,
        flags                 = flags,
        rasterizationSamples  = rasterizationSamples,
        sampleShadingEnable   = (b32)(sampleShadingEnable),
        minSampleShading      = minSampleShading,
        pSampleMask           = pSampleMask,
        alphaToCoverageEnable = (b32)(alphaToCoverageEnable),
        alphaToOneEnable      = (b32)(alphaToOneEnable),
    }
    return
}

DefaultDepthStencil :: proc(
    depthTestEnable: b8                            = false,
    depthWriteEnable: b8                           = false,
    depthCompareOp: vk.CompareOp                   = .LESS,
    depthBoundsTestEnable: b8                      = false,
    stencilTestEnable: b8                          = false,
    flags: vk.PipelineDepthStencilStateCreateFlags = {},
    minDepthBounds: f32                            = 0.0,
    maxDepthBounds: f32                            = 1.0,
    front: vk.StencilOpState                       = {},
    back: vk.StencilOpState                        = {},
    pNext: rawptr                                  = nil,
) -> (depthStencil: vk.PipelineDepthStencilStateCreateInfo) {
    depthStencil = {
        sType                   = .PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO,
        pNext                   = pNext,
        flags                   = flags,
        depthTestEnable         = (b32)(depthTestEnable),
        depthWriteEnable        = (b32)(depthWriteEnable),
        depthCompareOp          = depthCompareOp,
        depthBoundsTestEnable   = (b32)(depthBoundsTestEnable),
        stencilTestEnable       = (b32)(stencilTestEnable),
        front                   = front,
        back                    = back,
        minDepthBounds          = minDepthBounds,
        maxDepthBounds          = maxDepthBounds,
    }
    return
}

DefaultBlendAttachment :: proc(
    blendEnable: b8                        = false,
    colorWriteMask: vk.ColorComponentFlags = { .R, .G, .B, .A },
    srcColorBlendFactor: vk.BlendFactor    = .ONE,
    dstColorBlendFactor: vk.BlendFactor    = .ZERO,
    colorBlendOp: vk.BlendOp               = .ADD,
    srcAlphaBlendFactor: vk.BlendFactor    = .ONE,
    dstAlphaBlendFactor: vk.BlendFactor    = .ZERO,
    alphaBlendOp: vk.BlendOp               = .ADD,
) -> (blendAttachment: vk.PipelineColorBlendAttachmentState) {
    blendAttachment = {
        blendEnable         = (b32)(blendEnable),
        colorWriteMask      = colorWriteMask,
        srcColorBlendFactor = srcColorBlendFactor,
        dstColorBlendFactor = dstColorBlendFactor,
        colorBlendOp        = colorBlendOp,
        srcAlphaBlendFactor = srcAlphaBlendFactor,
        dstAlphaBlendFactor = dstAlphaBlendFactor,
        alphaBlendOp        = alphaBlendOp,
    }
    return
}

DefaultFillColorBlendAttachments :: proc(
    #any_int attachmentsCount: u32         = 0,
    colorWriteMask: vk.ColorComponentFlags = { .R, .G, .B, .A },
    blendEnable: b8                        = false,
) -> (colorBlendAttachments: []vk.PipelineColorBlendAttachmentState) {
    colorBlendAttachments = make([]vk.PipelineColorBlendAttachmentState, attachmentsCount)
    for &c in colorBlendAttachments {
        c = DefaultBlendAttachment(
            blendEnable    = blendEnable,
            colorWriteMask = colorWriteMask,
        )
    }
    return
}

DefaultColorBlending :: proc(
    #any_int attachmentsCount: u32                       = 0,
    attachments: [^]vk.PipelineColorBlendAttachmentState = {},
    logicOpEnable: b8                                    = false,
    logicOp: vk.LogicOp                                  = .COPY,
    blendConstants: [4]f32                               = {0, 0, 0, 0},
    pNext: rawptr                                        = nil,
    flags: vk.PipelineColorBlendStateCreateFlags         = {}
) -> (colorBlending: vk.PipelineColorBlendStateCreateInfo) {
    colorBlending = {
        sType                   = .PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
        pNext                   = pNext,
        flags                   = flags,
        logicOpEnable           = (b32)(logicOpEnable),
        logicOp                 = logicOp,
        attachmentCount         = attachmentsCount,
        pAttachments            = attachments,
        blendConstants          = blendConstants,
    }
    return
}

DefaultCreateDynamicStates :: proc(
    #any_int        dynamicStatesCount: u32   = 0,
    pDynamicStates: [^]vk.DynamicState        = nil,
    pNext: rawptr                             = nil,
    flags: vk.PipelineDynamicStateCreateFlags = {}
) -> (dynamicStatesInfo: vk.PipelineDynamicStateCreateInfo) {
    dynamicStatesInfo = {
        sType                   = .PIPELINE_DYNAMIC_STATE_CREATE_INFO,
        pNext                   = pNext,
        flags                   = flags,
        dynamicStateCount       = dynamicStatesCount,
        pDynamicStates          = pDynamicStates,
    }
    return
}

DefaultDynamicStates :: proc(
    states: ^[2]vk.DynamicState = nil
) -> (dynamicStatesInfo: vk.PipelineDynamicStateCreateInfo) {
    states^ = { .VIEWPORT, .SCISSOR }
    dynamicStatesInfo = DefaultCreateDynamicStates(
        2,
        raw_data(states),
    )

    return
}

DefaultPipelineLayoutCreateInfo :: proc(
    #any_int setLayoutsCount: u32             = 0,
    setLayouts: [^]vk.DescriptorSetLayout     = nil,
    pushConstantRangeCount: u32               = 0,
    pushConstantRanges: ^vk.PushConstantRange = nil,
    pNext: rawptr                             = nil,
    flags: vk.PipelineLayoutCreateFlags       = {}
) -> (pipelineLayoutInfo: vk.PipelineLayoutCreateInfo) {
    pipelineLayoutInfo = {
        sType                  = .PIPELINE_LAYOUT_CREATE_INFO,
        pNext                  = pNext,
        flags                  = flags,
        setLayoutCount         = setLayoutsCount,
        pSetLayouts            = setLayouts,
        pushConstantRangeCount = pushConstantRangeCount,
        pPushConstantRanges    = pushConstantRanges,
    }
    return
}

DefaultPipelineCacheInfo :: proc(
    #any_int initDataSize: int         = 0,
    initData: rawptr                   = nil,
    flags: vk.PipelineCacheCreateFlags = {},
    pNext: rawptr                      = nil
) -> (pipelineCacheInfo: vk.PipelineCacheCreateInfo) {
    pipelineCacheInfo = {
        sType      = .PIPELINE_CACHE_CREATE_INFO,
        pNext      = pNext,
        flags      = flags,
        initialDataSize = initDataSize,
        pInitialData    = initData,
    }
    return
}

DefaultPipelineEmptyCacheCreateInfo :: proc() -> (pipelineCacheInfo: vk.PipelineCacheCreateInfo) {
    pipelineCacheInfo = DefaultPipelineCacheInfo()
    return
}

// Pipeline Vertex Data
PipelineVertexData   :: #type struct{
    bindings:   [dynamic]vk.VertexInputBindingDescription,
    attributes: [dynamic]vk.VertexInputAttributeDescription,
}
CleanPipelineVertexData :: proc(data: ^PipelineVertexData) {
    delete(data.bindings)
    delete(data.attributes)
}
ChainedBindings :: #type struct{
    binding: vk.VertexInputBindingDescription,
    next:    ^ChainedBindings,
}
AddBinding_1 :: proc(data: ^PipelineVertexData, binding: vk.VertexInputBindingDescription) {
    append(&data.bindings, binding)
}
AddBindings_1 :: proc(data: ^PipelineVertexData, bindings: ..vk.VertexInputBindingDescription) {
    for &b in bindings {
        append(&data.bindings, b)
    }
}
AddBindings_2 :: proc(data: ^PipelineVertexData, bindingsCount: u32, bindings: [^]vk.VertexInputBindingDescription) { 
    for i := 0; i < int(bindingsCount); i += 1 {
        append(&data.bindings, bindings[i])
    }
}
AddBindings_3 :: proc(data: ^PipelineVertexData, chain: ^ChainedBindings) {
    append(&data.bindings, chain.binding)
    if chain.next != nil || chain.next != {} {
        AddBindings_3(data, chain.next)
    }
}
AddBinding :: proc{
    AddBinding_1,
    AddBindings_1,
    AddBindings_2,
    AddBindings_3,
}
ChainedAttributes :: #type struct{
    attribute: vk.VertexInputAttributeDescription,
    next:      ^ChainedAttributes,
}
AddAttribute_1 :: proc(data: ^PipelineVertexData, attribute: vk.VertexInputAttributeDescription) {
    append(&data.attributes, attribute)
}
AddAttributes_1 :: proc(data: ^PipelineVertexData, attributes: ..vk.VertexInputAttributeDescription) {
    for &a in attributes {
        append(&data.attributes, a)
    }
}
AddAttributes_2 :: proc(data: ^PipelineVertexData, attributesCount: u32, attributes: [^]vk.VertexInputAttributeDescription) {
    for i := 0; i < int(attributesCount); i += 1 {
        append(&data.attributes, attributes[i])
    }
}
AddAttributes_3 :: proc(data: ^PipelineVertexData, chain: ^ChainedAttributes) {
    append(&data.attributes, chain.attribute)
    if chain.next != nil || chain.next != {} {
        AddAttributes_3(data, chain.next)
    }
}
AddAttribute :: proc{
    AddAttribute_1,
    AddAttributes_1,
    AddAttributes_2,
    AddAttributes_3,
}

SetLayouts :: proc(
    layouts: ..vk.DescriptorSetLayout
) -> (layoutsArray: []vk.DescriptorSetLayout) {
    layoutsArray = make([]vk.DescriptorSetLayout, len(layouts))
    for l, i in layouts {
        layoutsArray[i] = l
    }
    return
}

PipelineLayout :: proc(
    data:     ^t.VulkanData               = nil,
    info:     ^vk.PipelineLayoutCreateInfo = nil,
    layout:   ^vk.PipelineLayout          = nil,
) -> (ok: bool = true) {
    using data
    log.debug("Creating Pipeline Layout")
    result := vk.CreatePipelineLayout(logical.device, info, allocations, layout)
    if result != .SUCCESS {
        log.error("Failed to create pipeline layout!")
        ok = false
        return
    }
    log.debug("Created Pipeline Layout")
    return
}

PipelineCache :: proc(
    data:     ^t.VulkanData               = nil,
    info:     ^vk.PipelineCacheCreateInfo = nil,
    cache:    ^vk.PipelineCache           = nil,
) -> (ok: bool = true) {
    using data
    log.debug("Creating Pipeline Cache")
    result := vk.CreatePipelineCache(logical.device, info, allocations, cache)
    if result != .SUCCESS {
        log.error("Failed to create pipeline cache!")
        ok = false
        return
    }
    log.debug("Created Pipeline Cache")

    return
}

GraphicsPipeline :: proc(
    data:     ^t.VulkanData        = nil,
    pipeline: ^vk.Pipeline         = nil,
    gpData:   t.GraphicsPipelineData = {}
) -> (ok: bool = true) {
    using data

    log.debug("Creating Graphics Pipeline")
    result := vk.CreateGraphicsPipelines(logical.device, gpData.cache^, gpData.infoCount, gpData.info, allocations, pipeline)
    if result != .SUCCESS {
        log.error("Failed to create graphics pipeline!")
        ok = false
        return
    }
    log.debug("Created Graphics Pipeline")

    return
}

GraphicsPipelineInfo_1 :: proc(
    states:               t.GraphicsInfoStates = {},
	stageCount:           int = 0,
	stages:               [^]vk.PipelineShaderStageCreateInfo = nil,
	layout:               vk.PipelineLayout = {},
    renderPass:           vk.RenderPass = {},
    pNext:                rawptr = nil,
	subpass:              u32 = 0,
    flags:                vk.PipelineCreateFlags = {},
    basePipelineIndex:    i32 = -1,
	basePipelineHandle:   vk.Pipeline = {},
) -> (pipelineCreateInfo: vk.GraphicsPipelineCreateInfo) {
    return {
        sType      = .GRAPHICS_PIPELINE_CREATE_INFO,
        pNext      = pNext,
        flags      = flags,
        pStages    = stages,
        stageCount = u32(stageCount),
        layout     = layout,
        renderPass = renderPass,
        subpass    = subpass,
        
        /* States */
        pVertexInputState   = states.vertex,
        pInputAssemblyState = states.assembly,
        pTessellationState  = states.tesselation,
        pViewportState      = states.viewport,
        pRasterizationState = states.raster,
        pMultisampleState   = states.multisample,
        pDepthStencilState  = states.depthStencil,
        pColorBlendState    = states.colorBlend,
        pDynamicState       = states.dynamics,

        /* Misc */
        basePipelineHandle = basePipelineHandle,
        basePipelineIndex  = basePipelineIndex,
    }
}

GraphicsPipelineInfo_2 :: proc(
    states:              t.GraphicsInfoStates = {},
	stageCount:          u32 = 0,
	stages:              [^]vk.PipelineShaderStageCreateInfo = nil,
	layout:              vk.PipelineLayout = {},
    renderPass:          vk.RenderPass = {},
    pNext:               rawptr = nil,
	subpass:             u32 = 0,
    flags:               vk.PipelineCreateFlags = {},
    basePipelineIndex:   i32 = -1,
	basePipelineHandle:  vk.Pipeline = {},
) -> (pipelineCreateInfo: vk.GraphicsPipelineCreateInfo) {
    return {
        sType      = .GRAPHICS_PIPELINE_CREATE_INFO,
        pNext      = pNext,
        flags      = flags,
        pStages    = stages,
        stageCount = stageCount,
        layout     = layout,
        renderPass = renderPass,
        subpass    = subpass,
        
        /* States */
        pVertexInputState   = states.vertex,
        pInputAssemblyState = states.assembly,
        pTessellationState  = states.tesselation,
        pViewportState      = states.viewport,
        pRasterizationState = states.raster,
        pMultisampleState   = states.multisample,
        pDepthStencilState  = states.depthStencil,
        pColorBlendState    = states.colorBlend,
        pDynamicState       = states.dynamics,

        /* Misc */
        basePipelineHandle = basePipelineHandle,
        basePipelineIndex  = basePipelineIndex,
    }
}

GraphicsPipelineInfo_3 :: proc(
    vertex:       ^vk.PipelineVertexInputStateCreateInfo,
	assembly:     ^vk.PipelineInputAssemblyStateCreateInfo,
	tesselation:  ^vk.PipelineTessellationStateCreateInfo,
	viewport:     ^vk.PipelineViewportStateCreateInfo,
	raster:       ^vk.PipelineRasterizationStateCreateInfo,
	multisample:  ^vk.PipelineMultisampleStateCreateInfo,
	depthStencil: ^vk.PipelineDepthStencilStateCreateInfo,
	colorBlend:   ^vk.PipelineColorBlendStateCreateInfo,
	dynamics:     ^vk.PipelineDynamicStateCreateInfo,

    stageCount:          int = 0,
	stages:              [^]vk.PipelineShaderStageCreateInfo,
	layout:              vk.PipelineLayout = {},
    renderPass:          vk.RenderPass = {},
    pNext:               rawptr = nil,
    subpass:             u32 = 0,
    flags:               vk.PipelineCreateFlags = {},
    basePipelineIndex:   i32 = -1,
	basePipelineHandle:  vk.Pipeline = {},
) -> (pipelineCreateInfo: vk.GraphicsPipelineCreateInfo) {
    return {
        sType      = .GRAPHICS_PIPELINE_CREATE_INFO,
        pNext      = pNext,
        flags      = flags,
        pStages    = stages,
        stageCount = u32(stageCount),
        layout     = layout,
        renderPass = renderPass,
        subpass    = subpass,
        
        /* States */
        pVertexInputState   = vertex,
        pInputAssemblyState = assembly,
        pTessellationState  = tesselation,
        pViewportState      = viewport,
        pRasterizationState = raster,
        pMultisampleState   = multisample,
        pDepthStencilState  = depthStencil,
        pColorBlendState    = colorBlend,
        pDynamicState       = dynamics,

        /* Misc */
        basePipelineHandle = basePipelineHandle,
        basePipelineIndex  = basePipelineIndex,
    }
}

GraphicsPipelineInfo_4 :: proc(
    vertex:       ^vk.PipelineVertexInputStateCreateInfo,
	assembly:     ^vk.PipelineInputAssemblyStateCreateInfo,
	tesselation:  ^vk.PipelineTessellationStateCreateInfo,
	viewport:     ^vk.PipelineViewportStateCreateInfo,
	raster:       ^vk.PipelineRasterizationStateCreateInfo,
	multisample:  ^vk.PipelineMultisampleStateCreateInfo,
	depthStencil: ^vk.PipelineDepthStencilStateCreateInfo,
	colorBlend:   ^vk.PipelineColorBlendStateCreateInfo,
	dynamics:     ^vk.PipelineDynamicStateCreateInfo,

    stageCount:          u32 = 0,
	stages:              [^]vk.PipelineShaderStageCreateInfo,
	layout:              vk.PipelineLayout = {},
    renderPass:          vk.RenderPass = {},
    pNext:               rawptr = nil,
    subpass:             u32 = 0,
    flags:               vk.PipelineCreateFlags = {},
    basePipelineIndex:   i32 = -1,
	basePipelineHandle:  vk.Pipeline = {},
) -> (pipelineCreateInfo: vk.GraphicsPipelineCreateInfo) {
    return {
        sType      = .GRAPHICS_PIPELINE_CREATE_INFO,
        pNext      = pNext,
        flags      = flags,
        pStages    = stages,
        stageCount = stageCount,
        layout     = layout,
        renderPass = renderPass,
        subpass    = subpass,
        
        /* States */
        pVertexInputState   = vertex,
        pInputAssemblyState = assembly,
        pTessellationState  = tesselation,
        pViewportState      = viewport,
        pRasterizationState = raster,
        pMultisampleState   = multisample,
        pDepthStencilState  = depthStencil,
        pColorBlendState    = colorBlend,
        pDynamicState       = dynamics,

        /* Misc */
        basePipelineHandle = basePipelineHandle,
        basePipelineIndex  = basePipelineIndex,
    }
}

GraphicsPipelineInfo :: proc{
    GraphicsPipelineInfo_1,
    GraphicsPipelineInfo_2,
    GraphicsPipelineInfo_3,
    GraphicsPipelineInfo_4,
}