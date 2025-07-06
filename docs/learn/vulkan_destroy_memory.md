# `memory.odin` (in `vulkan/destroy`)

This file provides a procedure for freeing Vulkan device memory.

## `Memory` procedure

This procedure frees a block of Vulkan device memory. It takes the `VulkanData` struct and a pointer to a `vk.DeviceMemory` handle as input. It calls `vk.FreeMemory` to free the underlying device memory.
