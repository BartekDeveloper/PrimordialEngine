package vk_create

import "core:log"
import "core:c"

import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"

LogicalDevice :: proc(data: ^t.VulkanData) -> () {
    using data

    queuePriority: f32 = 1.0
    logical.queueCreateInfos = make([]vk.DeviceQueueCreateInfo, len(data.physical.uniqueQueueFamilies))
    for q, i in physical.uniqueQueueFamilies {
        logical.queueCreateInfos[i] = {
            sType            = .DEVICE_QUEUE_CREATE_INFO,
            queueFamilyIndex = q,
            queueCount       = 1,
            pQueuePriorities = &queuePriority
        }
    }

    fmt.eprintfln("=*=*=*= Requested Device Extensions =*=*=*=")
    for &e in logical.extensions {
        fmt.eprintfln("\t%s", e) 
    }   
    fmt.eprintfln("=*=*=*= Requested Device Extensions =*=*=*=")
    
    logical.createInfo = {     
        sType                   = .DEVICE_CREATE_INFO,
        queueCreateInfoCount    = u32(len(logical.queueCreateInfos)),
        pQueueCreateInfos       = raw_data(logical.queueCreateInfos),
        enabledLayerCount       = 0   if !ENABLE_VALIDATION_LAYERS else u32(len(instance.layers)),
        ppEnabledLayerNames     = nil if !ENABLE_VALIDATION_LAYERS else raw_data(instance.layers),
        enabledExtensionCount   = u32(len(logical.extensions)),
        ppEnabledExtensionNames = raw_data(logical.extensions),
        pEnabledFeatures        = &logical.requestedFeatures
    }
    result := vk.CreateDevice(physical.device, &logical.createInfo, allocations, &logical.device)
    if result != .SUCCESS {
        panic("Failed to create Logical Device")
    }

    vk.load_proc_addresses(logical.device)

    vk.GetDeviceQueue(logical.device, physical.queues.idx.graphics, 0, &physical.queues.graphics)
    vk.GetDeviceQueue(logical.device, physical.queues.idx.present,  0, &physical.queues.present)
    vk.GetDeviceQueue(logical.device, physical.queues.idx.compute,  0, &physical.queues.compute)
    vk.GetDeviceQueue(logical.device, physical.queues.idx.transfer, 0, &physical.queues.transfer)


    return
}
