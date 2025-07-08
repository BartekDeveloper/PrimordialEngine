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

Pipelines :: proc(
    data: ^t.VulkanData = nil
) -> () {
    for k, &pipeline in data.pipelines {
        Pipeline(
            data,
            &pipeline
        )

        PipelineLayout(
            data,
            &pipeline.layout
        )
    }
    delete(data.pipelines)

    // NOTE(me): Idk should I  move it to other file?
    // NOTE(me): Prob i should, but i am too lazy to do it now
    delete(data.viewports)
    delete(data.scissors)

    return
}

PipelineLayout :: proc(
    data: ^t.VulkanData = nil,
    pipelineLayout: ^vk.PipelineLayout = nil
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
    pipeline: ^t.Pipeline = nil
) -> () {
    if pipeline.pipeline != {} {
        vk.DestroyPipeline(
            data.logical.device,
            pipeline.pipeline,
            data.allocations
        )
    }
    pipeline.createInfo = {}

    if pipeline.cache != {} {
        vk.DestroyPipelineCache(
            data.logical.device,
            pipeline.cache,
            data.allocations
        )
    }

    // if pipeline.shaders != nil {
    //     delete(pipeline.shaders)
    // }
    return
}
