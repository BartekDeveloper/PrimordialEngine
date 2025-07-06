# `logical_device.odin` (in `vulkan/destroy`)

This file provides a procedure for destroying the Vulkan logical device.

## `LogicalDevice` procedure

This procedure destroys the Vulkan logical device. It calls `vk.DestroyDevice` to destroy the underlying Vulkan device object and then frees the memory allocated for the queue create infos.
