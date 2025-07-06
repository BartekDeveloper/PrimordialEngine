# `instance.odin` (in `vulkan/destroy`)

This file provides a procedure for destroying the Vulkan instance and its associated debug messenger.

## `Instance` procedure

This procedure destroys the Vulkan instance. It performs the following steps:

1.  **Destroys Debug Messenger:** If a debug messenger was created, it destroys it using `vk.DestroyDebugUtilsMessengerEXT` and clears its associated info struct.
2.  **Destroys Instance:** It destroys the Vulkan instance using `vk.DestroyInstance` and clears its associated create info struct.
3.  **Frees Memory:** It frees the memory allocated for the instance's extensions and layers.
