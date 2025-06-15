package vk_create

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import "../load"
import t "../types"
import win "../../window"

Pipelines :: proc(data: ^t.VulkanData) -> () {
    using data;
    ctx = context
    good: bool = true


    viewports["global"] = {
        x        = 0,
        y        = 0,
        minDepth = 0,
        maxDepth = 1,
        width    = (f32)(swapchain.extent.width),
        height   = (f32)(swapchain.extent.height),
    }
    scissors["global"] = {
        offset = { x = 0, y = 0, },
        extent = swapchain.extent,
    }

    log.debug("Creating Pipelines")
    log.debug("\t Light")
    {
        log.debug("\t\t Creating Shaders")\
        p := pipelines["light"]
        
        p.shaders = {
            { "geometry.vert.spv", .VERTEX   },
            { "geometry.frag.spv", .FRAGMENT },
        }
        p.stages = ShaderStages(data, load.GetModule, ..p.shaders)
        p.setLayouts = { descriptors["ubo"].setLayout }

        pVertexData:          PipelineVertexData = {{}, {}}
        
        pDynamicStates:       [2]vk.DynamicState = {}
        pVertexInputInfo      := DefaultVertexInput(&pVertexData)
        pInputAssemblyInfo    := DefaultInputAssembly()
        pViewportState        := DefaultViewportState(1, 1)
        pRasterizationInfo    := DefaultRasterization()
        pMultisampleState     := DefaultMultisample()
        pDepthStencil         := DefaultDepthStencil(depthTestEnable = false)
        pColorBlendAttachment := DefaultFillColorBlendAttachments(1, blendEnable = false)[0]  
        pColorBlending        := DefaultColorBlending(1, &pColorBlendAttachment)
        pDynamicState         := DefaultDynamicStates(&pDynamicStates)

        pStates: GraphicsInfoStates = {
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
            u32(len(p.setLayouts)),
            raw_data(p.setLayouts)
        )
        good = PipelineLayout(data, &pPipelineLayoutCreateInfo, &p.layout)
        if !good {
            log.panic("Failed to create Pipeline Layout")
        }

        pCacheCreateInfo := DefaultPipelineEmptyCacheCreateInfo()
        good = PipelineCache(data, &pCacheCreateInfo, &p.cache)
        if !good {
            log.panic("Failed to create Pipeline Cache")
        }

        good = GraphicsPipeline(
            data,
            &p.pipeline,
            GraphicsPipelineData{
                cache     = &p.cache,
                infoCount = 1,
                info      = &p.createInfo.(vk.GraphicsPipelineCreateInfo),
            }
        )
        if !good {
            log.panic("Failed to create Graphics Pipeline")
        }
        log.info("Created `light` Graphics Pipeline")

        pipelines["light"] = p
    }

    return
}

DefaultVertexInput :: proc(
    data: ^PipelineVertexData
) -> (vertexInput: vk.PipelineVertexInputStateCreateInfo) {
    using data;

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
    lineWidth: f32                                  = 1,
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
    minDepthBounds: f32                            = 0,
    maxDepthBounds: f32                            = 1,
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
    srcColorBlendFactor: vk.BlendFactor    = .SRC_ALPHA,
    dstColorBlendFactor: vk.BlendFactor    = .ONE_MINUS_SRC_ALPHA,
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



/*
    Graphics Pipeline States
  
    @input vertex
    @input assembly
    @input viewport
    @input raster
    @input multisample
    @input depthStencil
    @input colorBlend
    @input dynamics

    @return self struct(GraphicsInfoStates)
*/
GraphicsInfoStates   :: #type struct{
    vertex:        ^vk.PipelineVertexInputStateCreateInfo,
    assembly:      ^vk.PipelineInputAssemblyStateCreateInfo,
    viewport:      ^vk.PipelineViewportStateCreateInfo,
    raster:        ^vk.PipelineRasterizationStateCreateInfo,
    multisample:   ^vk.PipelineMultisampleStateCreateInfo,
    depthStencil:  ^vk.PipelineDepthStencilStateCreateInfo,
    colorBlend:    ^vk.PipelineColorBlendStateCreateInfo,
    dynamics:      ^vk.PipelineDynamicStateCreateInfo,
}
GraphicsPipelineData :: #type struct{
    cache:     ^vk.PipelineCache,
    infoCount: u32,
    info:      [^]vk.GraphicsPipelineCreateInfo,
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
    using data;
    context = ctx
    log.debug("Creating Pipeline Layout")
    result := vk.CreatePipelineLayout(logical.device, info, nil, layout)
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
    return
}

GraphicsPipeline :: proc(
    data:     ^t.VulkanData        = nil,
    pipeline: ^vk.Pipeline         = nil,
    gpData:   GraphicsPipelineData = {}
) -> (ok: bool = true) {
    return
}

