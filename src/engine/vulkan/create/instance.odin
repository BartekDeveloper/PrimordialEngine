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

ENABLE_VALIDATION_LAYERS : bool : true

ctx: runtime.Context

VulkanDebugCallback :: proc "system" (
    messageSeverity: vk.DebugUtilsMessageSeverityFlagsEXT, 
    messageType: vk.DebugUtilsMessageTypeFlagsEXT,
    pCallbackData: ^vk.DebugUtilsMessengerCallbackDataEXT,
    pUserData: rawptr
) -> b32 {
    context = ctx
    fmt.eprintfln("! %s\n", pCallbackData.pMessage)
    return false
}

Instance :: proc(data: ^t.VulkanData, loc := #caller_location) -> () {
    using data;
    
    ctx = context

    log.infof("\t%s", loc)

    log.info("=*=*=*= VALIDATION LAYERS =*=*=*=")
    for i := 0; i < int(len(instance.layers)); i += 1 {
        log.infof("\t %s", instance.layers[i])
    }
    log.info("=*=*=*= VALIDATION LAYERS =*=*=*=")
    
    
    windowExt := win.GetInstanceExtensions()
    append(&instance.extensions, ..windowExt[:])
 
    log.info("=*=*=*= INSTANCE EXTENSIONS =*=*=*=")
    for i := 0; i < int(len(instance.extensions)); i += 1 {
        log.infof("\t %s", instance.extensions[i])
    }
    log.info(instance.extensions)
    log.info("=*=*=*= INSTANCE EXTENSIONS =*=*=*=")
   

    log.debug("\t Instance Info")
    instance.createInfo = {
        sType                   = .INSTANCE_CREATE_INFO,
        pApplicationInfo        = &appInfo,
        enabledExtensionCount   = u32(len(instance.extensions)),
        ppEnabledExtensionNames = raw_data(instance.extensions),
        enabledLayerCount       = 0   if !ENABLE_VALIDATION_LAYERS else u32(len(instance.layers)),
        ppEnabledLayerNames     = nil if !ENABLE_VALIDATION_LAYERS else raw_data(instance.layers),
        pNext                   = nil
    }

    if ENABLE_VALIDATION_LAYERS {
        log.debug("\t Creating debug messenger info")
        instance.messengerInfo = {
            sType           = .DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
            messageSeverity = { .VERBOSE, .WARNING, .ERROR, .INFO },
            messageType     = { .PERFORMANCE, .VALIDATION, .GENERAL },
            pfnUserCallback = VulkanDebugCallback,
            pUserData       = nil,
        }
        instance.createInfo.pNext = rawptr(&instance.messengerInfo)
    }

    log.debug(instance.createInfo)

    log.debug("\t Creating Instance")
    result := vk.CreateInstance(
        &instance.createInfo,
        nil,
        &instance.instance
    )
    log.debug(result)
    if result != .SUCCESS do panic("Failed to create instance!")
    log.info("Created Instance!")

    if ENABLE_VALIDATION_LAYERS {
        log.info("Creating messenger")
        
        result = vk.CreateDebugUtilsMessengerEXT(
            instance.instance,
            &instance.messengerInfo,
            nil,
            &instance.messenger
        )
        if result != .SUCCESS do panic("Failed to create messenger")
        
        log.info("Created messenger!")
    }

    return
}
