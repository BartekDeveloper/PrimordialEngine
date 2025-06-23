package vk_create

ENABLE_VALIDATION_LAYERS: bool : true

import "base:runtime"
import "core:c"
import "core:fmt"
import "core:log"
import "core:mem"


import vk "vendor:vulkan"

import win "../../window"
import t "../types"

ctx: runtime.Context

VulkanDebugCallback :: proc "system" (
	messageSeverity: vk.DebugUtilsMessageSeverityFlagsEXT,
	messageType: vk.DebugUtilsMessageTypeFlagsEXT,
	pCallbackData: ^vk.DebugUtilsMessengerCallbackDataEXT,
	pUserData: rawptr,
) -> b32 {
	context = ctx

    switch(messageSeverity) {
        case { .INFO }:
            /* FOR NOW NOT NEEDED */
            // fmt.eprintfln("! %s\n", pCallbackData.pMessage)
            break
        case { .WARNING }:
            fmt.eprintfln("! %s\n", pCallbackData.pMessage)
            break
        case { .ERROR }:
            fmt.eprintfln("! %s\n", pCallbackData.pMessage)
            break
        case { .VERBOSE }:
            /* REMBEMBER(me): Verbose is too much verbose */
            // fmt.eprintfln("! %s\n", pCallbackData.pMessage)
            break
        case:
            break
    }

	return false
}

Instance :: proc(data: ^t.VulkanData) {
	using data
	loc := #location()

	log.infof("\t%s", loc)

	fmt.eprintfln("=*=*=*= VALIDATION LAYERS =*=*=*=")
	for i := 0; i < int(len(instance.layers)); i += 1 {
		fmt.eprintfln("\t %s", instance.layers[i])
	}
	fmt.eprintfln("=*=*=*= VALIDATION LAYERS =*=*=*=")


	windowExt := win.GetInstanceExtensions()
    defer delete(windowExt)
    append(&instance.extensions, ..windowExt[:])

	fmt.eprintfln("=*=*=*= INSTANCE EXTENSIONS =*=*=*=")
	for i := 0; i < int(len(instance.extensions)); i += 1 {
		fmt.eprintfln("\t %s", instance.extensions[i])
	}
	fmt.eprintfln("=*=*=*= INSTANCE EXTENSIONS =*=*=*=")


	log.debug("\t Instance Info")
	instance.createInfo = {
		sType                   = .INSTANCE_CREATE_INFO,
		pApplicationInfo        = &appInfo,
		enabledExtensionCount   = u32(len(instance.extensions)),
		ppEnabledExtensionNames = raw_data(instance.extensions),
		enabledLayerCount       = 0 if !ENABLE_VALIDATION_LAYERS else u32(len(instance.layers)),
		ppEnabledLayerNames     = nil if !ENABLE_VALIDATION_LAYERS else raw_data(instance.layers),
		pNext                   = nil,
	}

	if ENABLE_VALIDATION_LAYERS {
		log.debug("\t Creating debug messenger info")
		instance.messengerInfo = {
			sType           = .DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
			messageSeverity = {.VERBOSE, .WARNING, .ERROR, .INFO},
			messageType     = {.PERFORMANCE, .VALIDATION, .GENERAL},
			pfnUserCallback = VulkanDebugCallback,
			pUserData       = nil,
		}
		instance.createInfo.pNext = rawptr(&instance.messengerInfo)
	}
	log.debug(instance.createInfo)

	log.debug("\t Creating Instance")
	result := vk.CreateInstance(&instance.createInfo, nil, &instance.instance)
	log.debug(result)
	if result != .SUCCESS do panic("Failed to create instance!")
	log.info("Created Instance!")
	log.assert(instance.instance != nil, "SOMEHOW: Instance is nil!")

	log.info("Loading instance addresses")
	vk.load_proc_addresses(data.instance.instance)

	if ENABLE_VALIDATION_LAYERS {
		log.info("Creating messenger")

		result = vk.CreateDebugUtilsMessengerEXT(
			instance.instance,
			&instance.messengerInfo,
			allocations,
			&instance.messenger,
		)
		log.debug(result)
		if result != .SUCCESS do panic("Failed to create messenger")

		log.info("Created messenger!")
	}

	return
}
