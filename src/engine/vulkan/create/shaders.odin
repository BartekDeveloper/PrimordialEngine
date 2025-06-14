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

ShaderStages :: proc(
    data: ^t.VulkanData = nil,
    fn: t.GetModuleProc  = load.GetModule,
    shaders: ..t.ShaderReference
) -> (stages: []vk.PipelineShaderStageCreateInfo) {
    good: bool = true
    stages = make([]vk.PipelineShaderStageCreateInfo, len(shaders))
    for &f, i in shaders {
        module := fn(f.name)
        if module == {} {
            good = false
            break
        }

        stages[i] = ShaderStage(module, f.stage)
    }
    return
}

ShaderStage :: proc(
    module: vk.ShaderModule                     = {},
    stage: vk.ShaderStageFlag                   = {},
    pSpecializationInfo: ^vk.SpecializationInfo = nil,
    pName: string                               = "main",
) -> (stageInfo: vk.PipelineShaderStageCreateInfo) {
    stageInfo = {
        sType  = .PIPELINE_SHADER_STAGE_CREATE_INFO,
        stage  = { stage },
        module = module,
        pName  = "main",
        pSpecializationInfo = nil,
    }
    return
}
