package vk_create

import "core:log"
import "core:c"

import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"

Samplers :: proc(data: ^t.VulkanData) -> () {
    using data
    log.debug("Creating Samplers")

    good: bool = true

    log.debug("Creating G-Buffer Sampler")
    {
        samplerInfo: vk.SamplerCreateInfo = {
            sType                   = .SAMPLER_CREATE_INFO,
            magFilter               = .NEAREST,
            minFilter               = .NEAREST,
            addressModeU            = .CLAMP_TO_EDGE,
            addressModeV            = .CLAMP_TO_EDGE,
            addressModeW            = .CLAMP_TO_EDGE,
            anisotropyEnable        = false,
            maxAnisotropy           = 1.0,
            borderColor             = .INT_OPAQUE_BLACK,
            unnormalizedCoordinates = false,
            compareEnable           = true,
            compareOp               = .ALWAYS,
            mipmapMode              = .NEAREST,
            mipLodBias              = 0.0,
            minLod                  = 0.0,
            maxLod                  = 0.0,
        }

        samplers["gBuffers"] = {}
        gBufferSampler := &samplers["gBuffers"]
        res := vk.CreateSampler(
            logical.device,
            &samplerInfo,
            allocations,
            gBufferSampler
        )
        if res != .SUCCESS {
            panic(fmt.aprintf("Failed to create G-Buffer sampler! Error: %v", res))
        }
    }
    return
}