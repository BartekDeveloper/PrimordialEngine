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

Pipelines :: proc(
    data: ^t.VulkanData = nil,
    ctx: rn.Context = {}
) -> () {
    
    for _, &pipeline in data.pipelines {
        Pipeline(
            data,
            &pipeline,
            ctx
        )

        PipelineLayout(
            data,
            &pipeline.layout,
            ctx
        )
    }

    return
}

PipelineLayout :: proc(
    data: ^t.VulkanData = nil,
    pipelineLayout: ^vk.PipelineLayout = nil,
    ctx: rn.Context = {}
) -> () {
    if pipelineLayout != {} {
        vk.DestroyPipelineLayout(
            data.logical.device,
            pipelineLayout^,
            data.allocations
        )
    }
    return
}

Pipeline :: proc(
    data: ^t.VulkanData = nil,
    pipeline: ^t.Pipeline = nil,
    ctx: rn.Context = {}
) -> () {
    if pipeline.pipeline != {} {
        vk.DestroyPipeline(
            data.logical.device,
            pipeline.pipeline,
            data.allocations
        )
    }
    return
}
