package vk_choose

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "base:runtime"

import vk "vendor:vulkan"

import t "../types"
import win "../../window"

PhysicalDevicesData :: proc(instance: vk.Instance, surface: vk.SurfaceKHR) -> (chosenPhysicalDeviceData: t.PhysicalDeviceData) {
    count: u32 = 0
    result := vk.EnumeratePhysicalDevices(instance, &count, nil)
    if result != .SUCCESS do log.panicf("Failed to enumerate Physical Devices: %s", result)
    if count  == 0        do panic("Count of Physical Devices is equal to 0!")

    devices := make([]vk.PhysicalDevice, count)
    result = vk.EnumeratePhysicalDevices(instance, &count, raw_data(devices))
    if result != .SUCCESS do log.panicf("Failed to enumerate Physical Devices: %s", result)
    log.assert(len(devices) != 0, "Physical Devices array is empty!")

    devicesData := make([]t.PhysicalDeviceData, count)
    for i := 0; i < int(count); i += 1 {
        devicesData[i] = t.PhysicalDeviceData{ device = devices[i], index = i }
    }

    scores: map[u32]int = {}
    // defer delete(scores)

    for h, i in devicesData {
        score: u32                  = 0
        data:  t.PhysicalDeviceData = {}

        surfaceInfo  := vk.PhysicalDeviceSurfaceInfo2KHR{
            sType               = .PHYSICAL_DEVICE_SURFACE_INFO_2_KHR,
            surface             = surface
        }
        capabilities := vk.SurfaceCapabilities2KHR{
            sType               = .SURFACE_CAPABILITIES_2_KHR,
            surfaceCapabilities = {}
        } 
        features     := vk.PhysicalDeviceFeatures2KHR{
            sType               = .PHYSICAL_DEVICE_FEATURES_2,
            features            = {}
        }
        properties   := vk.PhysicalDeviceProperties2KHR{
            sType               = .PHYSICAL_DEVICE_PROPERTIES_2,
            properties          = {}
        }
        memoryProps  := vk.PhysicalDeviceMemoryProperties2{
            sType               = .PHYSICAL_DEVICE_MEMORY_PROPERTIES_2,
            memoryProperties    = {}
        }

        vk.GetPhysicalDeviceFeatures2(h.device,  &features)
        vk.GetPhysicalDeviceProperties2(h.device, &properties)
        vk.GetPhysicalDeviceMemoryProperties2(h.device, &memoryProps)
        result = vk.GetPhysicalDeviceSurfaceCapabilities2KHR(h.device, &surfaceInfo, &capabilities)

        props  := properties.properties
        limits := props.limits
        feats  := features.features
        caps   := capabilities.surfaceCapabilities

        type: string
        #partial switch(props.deviceType) {
            case .CPU:
                type = "CPU"
                break
            case .VIRTUAL_GPU:
                type = "VIRTUAL_GPU"
                break
            case .INTEGRATED_GPU:
                type = "INTEGRATED_GPU"
                break
            case .DISCRETE_GPU:
                type = "DISCRETE_GPU"
                break
            case:
                type = "UNKNOWN"
        }
        log.infof("%s:\t %s", type, props.deviceName)
        

        queueFamiliesCount: u32 = 0
        queueFamilies:    []vk.QueueFamilyProperties2
        queueIndices: t.QueueIndices = { 
            ~u32(0),
            ~u32(0),
            ~u32(0),
            ~u32(0),
        }
        
        vk.GetPhysicalDeviceQueueFamilyProperties2(h.device,  &queueFamiliesCount, nil)

        queueFamilies = make([]vk.QueueFamilyProperties2, queueFamiliesCount)
        for &q, _ in queueFamilies{
            q = {
                sType                 = .QUEUE_FAMILY_PROPERTIES_2,
                queueFamilyProperties = {},
                pNext                 = nil
            }
        }
        vk.GetPhysicalDeviceQueueFamilyProperties2(h.device, &queueFamiliesCount, raw_data(queueFamilies))


        found: struct{
            present:  b32,
            graphics: b8,
            transfer: b8,
            compute:  b8,
        } = { false, false, false, false}
        for val, idx in queueFamilies {
            using data.queues.idx;

            fmt.eprintfln("QUEUE #%d", idx)
            v := val.queueFamilyProperties

            if !found.graphics && .GRAPHICS in v.queueFlags {
                fmt.eprintfln("Graphics queue found: %d", idx)
                graphics = u32(idx)
                found.graphics = true
            }

            if .COMPUTE in v.queueFlags {
                fmt.eprintfln("Compute queue found: %d", idx)
                compute = u32(idx) 
                found.compute = true
            }

            result = vk.GetPhysicalDeviceSurfaceSupportKHR(h.device, u32(idx), surface, &found.present)
            if result != .SUCCESS do log.panicf("Failed to acquire Physical Device Surface Support: %s", result)
            if !found.present {
                fmt.eprintfln("Present queue found: %d", idx)
                present = u32(idx) - 2
                found.present = true
            }

            if .TRANSFER in v.queueFlags {
                fmt.eprintfln("Transfer queue found: %d", idx)
                transfer = u32(idx)
                found.transfer = true
            }
        }
        
        fmt.eprintln("Found:\n")
        fmt.eprintfln("\t graphics? %s", "yes" if found.graphics else "no")
        fmt.eprintfln("\t present?  %s", "yes" if found.present  else "no")
        fmt.eprintfln("\t compute?  %s", "yes" if found.compute  else "no")
        fmt.eprintfln("\t transfer? %s", "yes" if found.transfer else "no")
        
        fmt.eprintln("Indices:\n")
        fmt.eprintfln("\t graphics?: %d", data.queues.idx.graphics)
        fmt.eprintfln("\t present?:  %d", data.queues.idx.present)
        fmt.eprintfln("\t compute?:  %d", data.queues.idx.compute)
        fmt.eprintfln("\t transfer?: %d", data.queues.idx.transfer)
        
        if !found.graphics || !found.present || !found.compute {
            log.error("Failed to find suitable queue families!")
            scores[u32(i)] = 0
            devicesData[i] = data
            continue
        }


        uniqueQueueFamilies: []u32      = {}
        unique:              map[u32]b8 = {}
        values := []u32{
            data.queues.idx.graphics,
            data.queues.idx.present,
            data.queues.idx.compute,
            data.queues.idx.transfer
        }
        for v in values {
            if _, exists := unique[v]; !exists {
                unique[v] = true
            }
        }
        uniqueQueueFamilies = make([]u32, len(unique))
        j := 0
        for ui, _ in unique {
            uniqueQueueFamilies[j] = ui 
            j += 1
        }
    
        fmt.eprintln(unique)
        fmt.eprintln(uniqueQueueFamilies)

        fmt.eprintfln("\t Max Image Dimensions %d", limits.maxImageDimension2D)
        score += limits.maxImageDimension2D
    
        fmt.eprintfln("\t Max Image Array Layers %d", limits.maxImageArrayLayers)
        score += limits.maxImageArrayLayers
        
        fmt.eprintfln("\t Max Sampler Anisotropy %.f", limits.maxSamplerAnisotropy)
        score += u32(limits.maxSamplerAnisotropy)

        fmt.eprintfln("\t Max Push Constant Size %d", limits.maxPushConstantsSize)

        mcwgs := limits.maxComputeWorkGroupSize
        fmt.eprintfln("\t Max Work Group Size %d x %d x %d", mcwgs.x, mcwgs.y, mcwgs.z)

        if !feats.samplerAnisotropy {
            log.warn("Sampler Anisotropy not supported!")
            score -= 10
        }

        if !feats.tessellationShader {
            log.warn("Tesselation Shader not supported!")
            score -= 10
        }

        score += u32(len(devices) - i)
         
        fmt.eprintfln("\nDevice %d: %s (%s)", i, props.deviceName, type)
        fmt.eprintfln("\tScore:\t%d\n", score)

        data.type                = type
        data.index               = int(i)
        data.features            = feats
        data.capabilities        = caps
        data.properties          = props
        data.device              = h.device
        data.memoryProperties    = memoryProps.memoryProperties 
        data.uniqueQueueFamilies = uniqueQueueFamilies

        scores[score]  = i
        devicesData[i] = data
    }

    log.info("Scoring Physical Devices")
    
    maxScore:  int = -1
    bestIndex: int = -1

    for score, idx in scores {
        log.debugf("score: %d, index: %d", score, idx)
        if int(score) >= maxScore {
            maxScore  = int(score)  
            bestIndex = idx
        }
    }
    
    log.infof("Best Device Index: %d", bestIndex)
    log.infof("Best Device Score: %d", maxScore)
    if bestIndex == -1 {
        log.panicf("No Physical Device Found!")
    }
    chosenPhysicalDeviceData = devicesData[bestIndex]

    return
}
