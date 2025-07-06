# `physical_device_data.odin` (in `vulkan/destroy`)

This file provides a procedure for destroying the physical device data.

## `PhysicalDeviceData` procedure

This procedure clears the physical device data stored in the `VulkanData` struct. It sets various fields related to the physical device (capabilities, properties, memory properties, formats, modes, and the device handle itself) to their zero-initialized states. It also deletes the `uniqueQueueFamilies` slice.
