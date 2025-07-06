# `instance.odin` (in `vulkan/create`)

This file handles the creation of the Vulkan instance, which is the first Vulkan object that needs to be created. It also sets up validation layers and debug callbacks.

## `ENABLE_VALIDATION_LAYERS` constant

A boolean constant that controls whether Vulkan validation layers are enabled. When enabled, validation layers provide detailed error messages and warnings, which are invaluable for debugging Vulkan applications.

## `VulkanDebugCallback` procedure

This is a C-compatible callback function that is invoked by the Vulkan validation layers when an event occurs (e.g., an error, warning, or information message). It logs the messages to the console.

## `Instance` procedure

This procedure creates the Vulkan instance. It performs the following steps:

1.  **Gathers Extensions and Layers:** It collects the necessary Vulkan instance extensions (including those required by the windowing system) and validation layers.
2.  **Configures Instance Creation Info:** It populates a `vk.InstanceCreateInfo` struct with information about the application, enabled extensions, and enabled layers.
3.  **Sets up Debug Messenger (if enabled):** If `ENABLE_VALIDATION_LAYERS` is true, it configures a `vk.DebugUtilsMessengerCreateInfoEXT` struct and links it to the instance creation info. This messenger uses the `VulkanDebugCallback` to report debug messages.
4.  **Creates Instance:** It calls `vk.CreateInstance` to create the Vulkan instance.
5.  **Loads Instance Addresses:** It loads the Vulkan function pointers specific to the created instance.
6.  **Creates Debug Messenger (if enabled):** If `ENABLE_VALIDATION_LAYERS` is true, it creates the debug messenger using `vk.CreateDebugUtilsMessengerEXT`.
